import UIKit

class StoreDetailsViewController: UIViewController,
                                 UITableViewDataSource,
                                 UITableViewDelegate,
                                 UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    // The store passed from HomeViewController
    var store: Store?

    // --- Existing search for items dropdown ---
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    private var dropdownItems: [String] = []

    // Local copy for filtered store items
    private var filteredStoreItems: [StoreItem] = []

    // Selected filters to apply
    private var selectedFilters: [String] = []

    // Available filter options
    private let filterOptions = [
        "Name: A-Z",
        "Name: Z-A",
        "Price: Low-High",
        "Price: High-Low",
        "Category: Furniture",
        "Category: Electronics",
        "Category: Food",
        "Category: Drinks"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = store {
            self.title = store.name
            filteredStoreItems = store.allStoreItems // Start with all items
        }

        setupSearchBar()
        setupMainTableView()
    }

    // MARK: - Search Bar
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()

        // Turn on the "bookmark" button to act as our filter icon
        searchBar.showsBookmarkButton = true
        searchBar.setImage(
            UIImage(systemName: "line.horizontal.3.decrease.circle"),
            for: .bookmark,
            state: .normal
        )

        navigationItem.titleView = searchBar
    }

    // Called when user taps the filter (bookmark) icon
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        showFilterActionSheet()
    }

    // MARK: - Apple Action Sheet for Filters
    private func showFilterActionSheet() {
        let actionSheet = UIAlertController(title: "Filter Options",
                                            message: "Select filters to apply",
                                            preferredStyle: .actionSheet)

        for option in filterOptions {
            let isSelected = selectedFilters.contains(option)

            let action = UIAlertAction(title: (isSelected ? "✅ " : "") + option,
                                        style: .default) { [weak self] _ in
                self?.toggleFilter(option)
            }

            actionSheet.addAction(action)
        }

        // Add a reset option
        let resetAction = UIAlertAction(title: "Reset Filters",
                                         style: .destructive) { [weak self] _ in
            self?.resetFilters()
        }
        actionSheet.addAction(resetAction)

        // Add a cancel option
        let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    private func toggleFilter(_ filter: String) {
        if selectedFilters.contains(filter) {
            // If filter is already selected, remove it
            selectedFilters.removeAll { $0 == filter }
        } else {
            // Add the new filter
            selectedFilters.append(filter)

            // Handle contradictory filters
            handleContradictoryFilters(for: filter)
        }

        applyFilters()
    }

    private func handleContradictoryFilters(for selectedFilter: String) {
        if selectedFilter == "Price: Low-High" {
            selectedFilters.removeAll { $0 == "Price: High-Low" }
        } else if selectedFilter == "Price: High-Low" {
            selectedFilters.removeAll { $0 == "Price: Low-High" }
        } else if selectedFilter == "Name: A-Z" {
            selectedFilters.removeAll { $0 == "Name: Z-A" }
        } else if selectedFilter == "Name: Z-A" {
            selectedFilters.removeAll { $0 == "Name: A-Z" }
        }
    }

    private func resetFilters() {
        selectedFilters.removeAll()
        filteredStoreItems = store?.allStoreItems ?? []
        tableView.reloadData()
    }

    // MARK: - Filtering Logic
    private func applyFilters() {
        guard let store = store else { return }

        filteredStoreItems = store.allStoreItems

        for filter in selectedFilters {
            switch filter {
            case "Name: A-Z":
                filteredStoreItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case "Name: Z-A":
                filteredStoreItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
            case "Price: Low-High":
                filteredStoreItems.sort {
                    let p1 = parsePrice($0.price) ?? 0
                    let p2 = parsePrice($1.price) ?? 0
                    return p1 < p2
                }
            case "Price: High-Low":
                filteredStoreItems.sort {
                    let p1 = parsePrice($0.price) ?? 0
                    let p2 = parsePrice($1.price) ?? 0
                    return p1 > p2
                }
            case let categoryFilter where categoryFilter.starts(with: "Category: "):
                let category = categoryFilter.replacingOccurrences(of: "Category: ", with: "")
                filteredStoreItems = filteredStoreItems.filter { $0.category == category }
            default:
                break
            }
        }

        tableView.reloadData()
    }

    // Helper to parse a "$XX.XX" string into a Double
    private func parsePrice(_ raw: String) -> Double? {
        let cleaned = raw.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }

    // MARK: - Main TableView
    func setupMainTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
        tableView.register(BestSellingItemsTableViewCell.self, forCellReuseIdentifier: "bestSellingCell")
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: "allItemsCell")
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath) as! StoreInfoTableViewCell
            if let store = store {
                cell.configure(with: store)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bestSellingCell", for: indexPath) as! BestSellingItemsTableViewCell
            if let store = store {
                cell.configure(with: store.bestSellingItems)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "allItemsCell", for: indexPath) as! AllItemsTableViewCell
            cell.configure(with: filteredStoreItems)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
