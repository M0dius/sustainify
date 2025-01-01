// StoreDetailsViewController.swift

import UIKit

class StoreDetailsViewController: UIViewController,
                                  UITableViewDataSource,
                                  UITableViewDelegate,
                                  UISearchBarDelegate,
                                  AllItemsTableViewCellDelegate,
                                  BestSellingItemsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var store: Store?
    
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    private var dropdownItems: [StoreItem] = []
    
    private var filteredStoreItems: [StoreItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = store {
            self.title = store.name
            filteredStoreItems = store.allStoreItems // For the "All Items" cell
        }

        setupSearchBar()
        setupMainTableView()
        setupItemDropdown()
    }

    // MARK: - Search Bar Setup
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()

        // Filter icon
        searchBar.showsBookmarkButton = true
        searchBar.setImage(
            UIImage(systemName: "line.horizontal.3.decrease.circle"),
            for: .bookmark,
            state: .normal
        )

        navigationItem.titleView = searchBar
    }

    // MARK: - Search Bar Actions
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Show filter action sheet
        showFilterActionSheet()
    }

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

    // MARK: - Main Table View Setup
    func setupMainTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
        tableView.register(BestSellingItemsTableViewCell.self, forCellReuseIdentifier: "bestSellingCell")
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: "allItemsCell")
    }

    // MARK: - Item Dropdown Setup
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
        let actionSheet = UIAlertController(
            title: "Filter Options",
            message: "Select one or more filters",
            preferredStyle: .actionSheet
        )

        let nameAZ = UIAlertAction(title: "Name: A-Z", style: .default) { _ in
            self.applyFilter("Name: A-Z")
        }
        let nameZA = UIAlertAction(title: "Name: Z-A", style: .default) { _ in
            self.applyFilter("Name: Z-A")
        }
        let priceLowHigh = UIAlertAction(title: "Price: Low-High", style: .default) { _ in
            self.applyFilter("Price: Low-High")
        }
        let priceHighLow = UIAlertAction(title: "Price: High-Low", style: .default) { _ in
            self.applyFilter("Price: High-Low")
        }

        actionSheet.addAction(nameAZ)
        actionSheet.addAction(nameZA)
        actionSheet.addAction(priceLowHigh)
        actionSheet.addAction(priceHighLow)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(actionSheet, animated: true)
    }

    func applyFilter(_ filter: String) {
        guard let store = store else { return }
        filteredStoreItems = store.allStoreItems

        switch filter {
        case "Name: A-Z":
            filteredStoreItems.sort {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case "Name: Z-A":
            filteredStoreItems.sort {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
            }
        case "Price: Low-High":
            filteredStoreItems.sort {
                Double($0.price.dropFirst()) ?? 0 < Double($1.price.dropFirst()) ?? 0
            }
        case "Price: High-Low":
            filteredStoreItems.sort {
                Double($0.price.dropFirst()) ?? 0 > Double($1.price.dropFirst()) ?? 0
            }
        default:
            break
        }

        let mainIndexPath = IndexPath(row: 2, section: 0)
        tableView.reloadRows(at: [mainIndexPath], with: .automatic)
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return dropdownItems.count
        } else {
            return 3 // storeInfoCell, bestSellingCell, allItemsCell
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dropdownTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath) as! DropdownItemCell
            let item = dropdownItems[indexPath.row]
            cell.configure(itemImage: UIImage(named: item.imageName),
                           itemName: item.name,
                           itemPrice: item.price)
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "storeInfoCell",
                    for: indexPath
                ) as! StoreInfoTableViewCell
                if let store = store {
                    cell.configure(with: store)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "bestSellingCell",
                    for: indexPath
                ) as! BestSellingItemsTableViewCell
                if let store = store {
                    cell.configure(with: store.mostSustainableItems)
                }
                // Set ourselves as delegate
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "allItemsCell",
                    for: indexPath
                ) as! AllItemsTableViewCell
                cell.configure(with: filteredStoreItems)
                cell.delegate = self // So we know which item was tapped
                return cell
            default:
                return UITableViewCell()
            }
        }
    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        if tableView == dropdownTableView {
            let tappedItem = dropdownItems[indexPath.row]
            isDropdownVisible = false
            dropdownTableView.isHidden = true
            searchBar.resignFirstResponder()
            
            // Show popup
            presentSustainabilityPopup(for: tappedItem)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - AllItemsTableViewCellDelegate
    func didSelectItem(_ item: StoreItem) {
        // Called by the "All Items" cell
        presentSustainabilityPopup(for: item)
    }

    // MARK: - BestSellingItemsTableViewCellDelegate
    func didTapSustainableItem(_ item: StoreItem) {
        // Called by the "Most Sustainable" item tap
        presentSustainabilityPopup(for: item)
    }

    // MARK: - Present the Popup
    private func presentSustainabilityPopup(for item: StoreItem) {
        guard let store = store else { return }
        
        let popupVC = SustainabilityPopupViewController()
        popupVC.modalPresentationStyle = .pageSheet // or .overCurrentContext, etc.
        popupVC.originalItem = item
        popupVC.store = store
        self.present(popupVC, animated: true, completion: nil)
    }
}
