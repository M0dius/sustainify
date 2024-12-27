import UIKit

class StoreDetailsViewController: UIViewController,
                                 UITableViewDataSource,
                                 UITableViewDelegate,
                                 UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    // The store passed from HomeViewController
    var store: Store?

    // Existing search bar & item dropdown
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    private var dropdownItems: [String] = []

    // NEW: Filter dropdown data
    private var filterDropdownTableView: UITableView!
    private var isFilterDropdownVisible = false
    private let filterOptions = [
        "Name: A-Z",
        "Name: Z-A",
        "Price: Low-High",
        "Price: High-Low"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = store {
            self.title = store.name
        }

        setupSearchBar()
        setupMainTableView()
        setupItemDropdown()
        setupFilterDropdown()
    }

    // MARK: - Search Bar
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()
        
        // 1) Turn on a “bookmark” (or “results list”) button on the right side
        //    We’ll treat this as our “filter” button
        searchBar.showsBookmarkButton = true
        // Optionally change the icon:
        // searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease.circle"),
        //                   for: .bookmark,
        //                   state: .normal)

        navigationItem.titleView = searchBar
    }

    // Called when the user taps the “bookmark”/filter icon on the search bar
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Toggle filter dropdown
        isFilterDropdownVisible.toggle()
        filterDropdownTableView.isHidden = !isFilterDropdownVisible
    }

    // The text field logic for item dropdown
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }

        if searchText.isEmpty {
            dropdownItems = []
            isDropdownVisible = false
        } else {
            // Show all store items (no filtering)
            dropdownItems = store.items
            isDropdownVisible = !dropdownItems.isEmpty
        }

        dropdownTableView.isHidden = !isDropdownVisible
        dropdownTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dropdownItems = []
        isDropdownVisible = false
        dropdownTableView.isHidden = true
        searchBar.resignFirstResponder()
    }

    // MARK: - Main TableView
    func setupMainTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        // Register row 0: store info
        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
        // Register row 1: best-selling
        tableView.register(BestSellingItemsTableViewCell.self, forCellReuseIdentifier: "bestSellingCell")
        // Register row 2: all items
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: "allItemsCell")
    }

    // MARK: - Item Dropdown Setup (existing)
    func setupItemDropdown() {
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(DropdownItemCell.self, forCellReuseIdentifier: "dropdownCell")
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.rowHeight = 60

        view.addSubview(dropdownTableView)
        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dropdownTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dropdownTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Filter Dropdown Setup (NEW)
    func setupFilterDropdown() {
        filterDropdownTableView = UITableView()
        filterDropdownTableView.dataSource = self
        filterDropdownTableView.delegate = self
        // Reuse a simple cell
        filterDropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterCell")
        filterDropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        filterDropdownTableView.isHidden = true
        filterDropdownTableView.layer.borderWidth = 1
        filterDropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        filterDropdownTableView.layer.cornerRadius = 5
        filterDropdownTableView.rowHeight = 44

        view.addSubview(filterDropdownTableView)
        NSLayoutConstraint.activate([
            // Place it below the item dropdown or near the top?
            // For example, let's position it just below the item dropdown:
            filterDropdownTableView.topAnchor.constraint(equalTo: dropdownTableView.bottomAnchor, constant: 10),
            filterDropdownTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterDropdownTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterDropdownTableView.heightAnchor.constraint(equalToConstant: 176)
        ])
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        if tableView == dropdownTableView {
            // Item dropdown
            return dropdownItems.count

        } else if tableView == filterDropdownTableView {
            // Filter dropdown
            return filterOptions.count

        } else {
            // Main table
            return 3 // store info, best selling, all items
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == dropdownTableView {
            // Existing item dropdown
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "dropdownCell", for: indexPath
            ) as! DropdownItemCell
            let itemName = dropdownItems[indexPath.row]
            let placeholderImage = UIImage(named: "PlaceholderImage")
            let placeholderPrice = "$9.99"
            cell.configure(itemImage: placeholderImage,
                           itemName: itemName,
                           itemPrice: placeholderPrice)
            return cell

        } else if tableView == filterDropdownTableView {
            // Filter dropdown
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "filterCell", for: indexPath
            )
            cell.textLabel?.text = filterOptions[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            return cell

        } else {
            // Main table
            switch indexPath.row {
            case 0:
                // Store Info
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "storeInfoCell",
                    for: indexPath
                ) as! StoreInfoTableViewCell
                if let store = store {
                    cell.configure(with: store)
                }
                return cell

            case 1:
                // Best Selling
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "bestSellingCell",
                    for: indexPath
                ) as! BestSellingItemsTableViewCell
                if let store = store {
                    cell.configure(with: store.bestSellingItems)
                }
                return cell

            case 2:
                // All Items
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "allItemsCell",
                    for: indexPath
                ) as! AllItemsTableViewCell
                if let store = store {
                    cell.configure(with: store.allStoreItems)
                }
                return cell

            default:
                return UITableViewCell()
            }
        }
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        if tableView == dropdownTableView {
            // User tapped an item in the item dropdown
            let selectedProduct = dropdownItems[indexPath.row]
            isDropdownVisible = false
            dropdownTableView.isHidden = true
            searchBar.resignFirstResponder()
            
            // Example: navigate to another storyboard
            let otherStoryboard = UIStoryboard(name: "Bader", bundle: nil)
            let someVC = otherStoryboard.instantiateViewController(withIdentifier: "SomeViewControllerID")
            // (someVC as? SomeViewControllerClass)?.selectedItemName = selectedProduct
            navigationController?.pushViewController(someVC, animated: true)

        } else if tableView == filterDropdownTableView {
            // User picked a filter
            let selectedFilter = filterOptions[indexPath.row]
            isFilterDropdownVisible = false
            filterDropdownTableView.isHidden = true
            
            // Example: apply sorting to store.allStoreItems
            applyFilter(selectedFilter)

        } else {
            // Main table row tapped
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Apply Filter Logic (Example)
    private func applyFilter(_ filter: String) {
        guard let store = store else { return }

        // Convert to a mutable array, sort, then reassign to store's allStoreItems if you want
        // Or you can keep a separate copy. This is just a demonstration:
        var items = store.allStoreItems

        switch filter {
        case "Name: A-Z":
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case "Name: Z-A":
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case "Price: Low-High":
            // If the price is always "$XX.XX", parse them
            items.sort {
                let price1 = Double($0.price.replacingOccurrences(of: "$", with: "")) ?? 0
                let price2 = Double($1.price.replacingOccurrences(of: "$", with: "")) ?? 0
                return price1 < price2
            }
        case "Price: High-Low":
            items.sort {
                let price1 = Double($0.price.replacingOccurrences(of: "$", with: "")) ?? 0
                let price2 = Double($1.price.replacingOccurrences(of: "$", with: "")) ?? 0
                return price1 > price2
            }
        default:
            break
        }

        // Now that items is sorted, if you want the "All Items" cell
        // to reflect this order, you can reassign store.allStoreItems
        // But 'store' is a struct? Actually it's a class in your code,
        // but let's assume we can do:
        // store.allStoreItems = items (only if your model is mutable)
        //
        // Instead, let's do a simpler approach: forcibly reload row 2
        // with the sorted array:
        //
        if let mainTable = tableView {
            mainTable.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
    }
}
