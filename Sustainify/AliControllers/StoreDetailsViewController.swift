import UIKit

class StoreDetailsViewController: UIViewController,
                                 UITableViewDataSource,
                                 UITableViewDelegate,
                                 UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // The store passed from HomeViewController
    var store: Store?
    
    // Search bar & dropdown data
    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var isDropdownVisible = false
    
    // We’ll show all store items in the dropdown (no filtering).
    private var dropdownItems: [String] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let store = store {
            self.title = store.name
        }
        
        setupSearchBar()
        setupTableView()
        setupDropdown()
    }
    
    // MARK: - Search Bar
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    // When user types in search, show/hide dropdown with store items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }
        
        if searchText.isEmpty {
            // Hide if no text
            dropdownItems = []
            isDropdownVisible = false
        } else {
            // Show all items (no filter)
            dropdownItems = store.items
            isDropdownVisible = !dropdownItems.isEmpty
        }
        
        dropdownTableView.isHidden = !isDropdownVisible
        dropdownTableView.reloadData()
    }
    
    // Optional: Hide dropdown on Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dropdownItems = []
        isDropdownVisible = false
        dropdownTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Main TableView Setup
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        // Register the store info cell
        tableView.register(StoreInfoTableViewCell.self,
                           forCellReuseIdentifier: "storeInfoCell")
        
        // Register the best selling items cell
        tableView.register(BestSellingItemsTableViewCell.self,
                           forCellReuseIdentifier: "bestSellingCell")
    }
    
    // MARK: - Dropdown Setup
    func setupDropdown() {
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(UITableViewCell.self,
                                   forCellReuseIdentifier: "dropdownCell")
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.rowHeight = 44
        
        view.addSubview(dropdownTableView)
        
        NSLayoutConstraint.activate([
            // Position the dropdown near the top
            dropdownTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            dropdownTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10
            ),
            dropdownTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10
            ),
            dropdownTableView.heightAnchor.constraint(
                equalToConstant: 200
            )
        ])
    }
    
    // MARK: - TableView Data Source (Shared by Main & Dropdown)
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        if tableView == dropdownTableView {
            // Dropdown table
            return dropdownItems.count
        } else {
            // Main table → 2 rows
            // Row 0: Store Info
            // Row 1: Best Selling Items
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dropdownTableView {
            // Dropdown cell
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "dropdownCell",
                for: indexPath
            )
            cell.textLabel?.text = dropdownItems[indexPath.row]
            return cell
        } else {
            // Main table
            switch indexPath.row {
            case 0:
                // Store info cell
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "storeInfoCell",
                    for: indexPath
                ) as! StoreInfoTableViewCell
                if let store = store {
                    cell.configure(with: store)
                }
                return cell
            case 1:
                // Best selling items cell
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "bestSellingCell",
                    for: indexPath
                ) as! BestSellingItemsTableViewCell
                cell.configure()
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    // MARK: - TableView Delegate (Handling Selections)
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        if tableView == dropdownTableView {
            // User selected an item from the dropdown
            let selectedProduct = dropdownItems[indexPath.row]
            
            // Hide the dropdown
            isDropdownVisible = false
            dropdownTableView.isHidden = true
            searchBar.resignFirstResponder()
            
            // Navigate to another storyboard
            let otherStoryboard = UIStoryboard(
                name: "Bader",
                bundle: nil
            )
            let someVC = otherStoryboard.instantiateViewController(
                withIdentifier: "SomeViewControllerID"
            )
            // (someVC as? SomeViewControllerClass)?.selectedItemName = selectedProduct
            
            navigationController?.pushViewController(someVC, animated: true)
            
        } else {
            // If user taps row 0 or 1 in main table
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
