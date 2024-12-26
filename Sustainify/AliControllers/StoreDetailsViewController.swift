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
    
    // We'll show all store items in the dropdown (no filtering).
    private var dropdownItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let store = store {
            self.title = store.name
        }
        
        setupSearchBar()
        setupMainTableView()
        setupDropdown()
    }
    
    // MARK: - Search Bar
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }
        
        if searchText.isEmpty {
            dropdownItems = []
            isDropdownVisible = false
        } else {
            // Show all store items
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
        
        // Row 0: store info
        tableView.register(StoreInfoTableViewCell.self,
                           forCellReuseIdentifier: "storeInfoCell")
        
        // Row 1: best-selling
        tableView.register(BestSellingItemsTableViewCell.self,
                           forCellReuseIdentifier: "bestSellingCell")
        
        // Row 2: all items
        tableView.register(AllItemsTableViewCell.self,
                           forCellReuseIdentifier: "allItemsCell")
    }
    
    // MARK: - Dropdown
    func setupDropdown() {
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(DropdownItemCell.self,
                                   forCellReuseIdentifier: "dropdownCell")
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
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return dropdownItems.count
        } else {
            // Now 3 rows:
            // row 0 -> store info
            // row 1 -> best selling
            // row 2 -> all items
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dropdownTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell",
                                                     for: indexPath) as! DropdownItemCell
            let itemName = dropdownItems[indexPath.row]
            let placeholderImage = UIImage(named: "PlaceholderImage")
            let placeholderPrice = "$9.99"
            
            cell.configure(itemImage: placeholderImage,
                           itemName: itemName,
                           itemPrice: placeholderPrice)
            return cell
            
        } else {
            switch indexPath.row {
            case 0:
                // Store info
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
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownTableView {
            let selectedProduct = dropdownItems[indexPath.row]
            // Hide dropdown
            isDropdownVisible = false
            dropdownTableView.isHidden = true
            searchBar.resignFirstResponder()
            
            // Navigate to another storyboard
            let otherStoryboard = UIStoryboard(name: "Bader", bundle: nil)
            let someVC = otherStoryboard.instantiateViewController(withIdentifier: "SomeViewControllerID")
            // (someVC as? SomeViewControllerClass)?.selectedItemName = selectedProduct
            navigationController?.pushViewController(someVC, animated: true)
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
