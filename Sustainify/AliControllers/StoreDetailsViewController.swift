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
    // If you want real prices & images, see the note below about item model data.
    private var dropdownItems: [String] = []
    
    // MARK: - View Life Cycle
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
    
    // Show/hide dropdown with store items when user types
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }
        
        if searchText.isEmpty {
            dropdownItems = []
            isDropdownVisible = false
        } else {
            // Show all store items, ignoring the actual text
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
    
    // MARK: - Main TableView (Store Info + Best Selling Items)
    func setupMainTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        // Store info cell
        tableView.register(
            StoreInfoTableViewCell.self,
            forCellReuseIdentifier: "storeInfoCell"
        )
        
        // Best selling items cell
        tableView.register(
            BestSellingItemsTableViewCell.self,
            forCellReuseIdentifier: "bestSellingCell"
        )
    }
    
    // MARK: - Dropdown TableView
    func setupDropdown() {
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        
        // Register our custom cell for the dropdown
        dropdownTableView.register(
            DropdownItemCell.self,
            forCellReuseIdentifier: "dropdownCell"
        )
        
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.rowHeight = 60 // so we have enough space for image
        
        view.addSubview(dropdownTableView)
        
        NSLayoutConstraint.activate([
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
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return dropdownItems.count
        } else {
            // Main table → 2 rows
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dropdownTableView {
            // We are in the dropdown
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "dropdownCell",
                for: indexPath
            ) as! DropdownItemCell
            
            // For now, store.items is an array of strings
            let itemName = dropdownItems[indexPath.row]
            
            // If you had real images & prices, you'd do something like:
            // let itemImage = UIImage(named: "someImageName")
            // let itemPrice = "$4.99"
            
            // For now, let's just use a placeholder image & price
            let placeholderImage = UIImage(named: "PlaceholderImage")
            let placeholderPrice = "$9.99"
            
            cell.configure(
                itemImage: placeholderImage,
                itemName: itemName,
                itemPrice: placeholderPrice
            )
            
            return cell
            
        } else {
            // We are in the main table
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
                cell.configure()
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
            // The user tapped an item in the dropdown
            let selectedProduct = dropdownItems[indexPath.row]
            
            // Hide the dropdown
            isDropdownVisible = false
            dropdownTableView.isHidden = true
            searchBar.resignFirstResponder()
            
            // Navigate to another storyboard
            let otherStoryboard = UIStoryboard(name: "Bader", bundle: nil)
            let someVC = otherStoryboard.instantiateViewController(withIdentifier: "SomeViewControllerID")
            
            // Pass the selected product if you want:
            // (someVC as? SomeViewControllerClass)?.selectedItemName = selectedProduct
            
            navigationController?.pushViewController(someVC, animated: true)
            
        } else {
            // Main table row tapped
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
