//
//  StoreDetailsViewController.swift
//

import UIKit

class StoreDetailsViewController: UIViewController,
                                  UITableViewDataSource,
                                  UITableViewDelegate,
                                  UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    // The store passed from HomeViewController
    var store: Store?

    // Existing search for items dropdown
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    private var dropdownItems: [StoreItem] = []

    // Local copy for filtered store items
    private var filteredStoreItems: [StoreItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = store {
            self.title = store.name
            filteredStoreItems = store.allStoreItems // Start with all items
        }

        setupSearchBar()
        setupMainTableView()
        setupItemDropdown()
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

    // MARK: - Searching logic (dropdown for items)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }

        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            dropdownItems = []
            isDropdownVisible = false
        } else {
            dropdownItems = store.allStoreItems.filter {
                $0.name.lowercased().contains(trimmedText.lowercased())
            }
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

        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
        tableView.register(BestSellingItemsTableViewCell.self, forCellReuseIdentifier: "bestSellingCell")
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: "allItemsCell")
    }

    // MARK: - Item Dropdown
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

    // MARK: - Filter Action Sheet
    func showFilterActionSheet() {
        let actionSheet = UIAlertController(title: "Filter Options", message: "Select one or more filters", preferredStyle: .actionSheet)

        let nameAZAction = UIAlertAction(title: "Name: A-Z", style: .default) { _ in
            self.applyFilter("Name: A-Z")
        }
        let nameZAAction = UIAlertAction(title: "Name: Z-A", style: .default) { _ in
            self.applyFilter("Name: Z-A")
        }
        let priceLowHighAction = UIAlertAction(title: "Price: Low-High", style: .default) { _ in
            self.applyFilter("Price: Low-High")
        }
        let priceHighLowAction = UIAlertAction(title: "Price: High-Low", style: .default) { _ in
            self.applyFilter("Price: High-Low")
        }

        // Add actions
        actionSheet.addAction(nameAZAction)
        actionSheet.addAction(nameZAAction)
        actionSheet.addAction(priceLowHighAction)
        actionSheet.addAction(priceHighLowAction)

        // Cancel action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Present the action sheet
        present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return dropdownItems.count
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropdownTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! DropdownItemCell
            let item = dropdownItems[indexPath.row]
            cell.configure(itemImage: UIImage(named: item.imageName), itemName: item.name, itemPrice: item.price)
            return cell
        } else {
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
                    cell.configure(with: store.mostSustainableItems)
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
    }

    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView && indexPath.row == 1 { // Most Sustainable Items section
            if let selectedItem = store?.mostSustainableItems[indexPath.row] {
                print("Selected Item: \(selectedItem.name)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - applyFilter for "All Items"
    private func applyFilter(_ filter: String) {
        guard let store = store else { return }

        filteredStoreItems = store.allStoreItems

        switch filter {
        case "Name: A-Z":
            filteredStoreItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case "Name: Z-A":
            filteredStoreItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case "Price: Low-High":
            filteredStoreItems.sort {
                let p1 = Double($0.price.dropFirst()) ?? 0
                let p2 = Double($1.price.dropFirst()) ?? 0
                return p1 < p2
            }
        case "Price: High-Low":
            filteredStoreItems.sort {
                let p1 = Double($0.price.dropFirst()) ?? 0
                let p2 = Double($1.price.dropFirst()) ?? 0
                return p1 > p2
            }
        default:
            break
        }

        let mainIndexPath = IndexPath(row: 2, section: 0)
        tableView.reloadRows(at: [mainIndexPath], with: .automatic)
    }
}
