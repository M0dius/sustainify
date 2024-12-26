import UIKit

class StoreDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {


    @IBOutlet weak var tableView: UITableView!
    var store: Store? // Store object passed from HomeViewController

    private let searchBar = UISearchBar()
    private var dropdownTableView: UITableView!
    private var filteredProducts: [String] = [] // Holds search results
    private var isDropdownVisible = false // Tracks dropdown visibility
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigation title to the store's name
        if let store = store {
            self.title = store.name
        }
        
        setupSearchBar()
        setupTableView()
        setupDropdown()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search items..."
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        // Register custom cell
        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
    }
    
    func setupDropdown() {
        dropdownTableView = UITableView()
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "dropdownCell")
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.lightGray.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.rowHeight = 44

        view.addSubview(dropdownTableView)
        
        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dropdownTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dropdownTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 200) // Adjust the height as needed
        ])
    }

    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let store = store else { return }
        if searchText.isEmpty {
            filteredProducts = []
            dropdownTableView.isHidden = true
            isDropdownVisible = false
        } else {
            filteredProducts = store.items.filter { $0.lowercased().contains(searchText.lowercased()) }
            dropdownTableView.isHidden = filteredProducts.isEmpty
            isDropdownVisible = !filteredProducts.isEmpty
        }
        dropdownTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Table View Data Source (Main Table View)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dropdownTableView {
            return filteredProducts.count
        } else {
            return 1 // Only one cell for the store info
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dropdownTableView {
            // Dropdown Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath)
            cell.textLabel?.text = filteredProducts[indexPath.row]
            return cell
        } else {
            // Main Store Info Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath) as! StoreInfoTableViewCell
            if let store = store {
                cell.configure(with: store)
            }
            return cell
        }
    }
    
    // MARK: - Table View Delegate (Dropdown Table View)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dropdownTableView {
            let selectedProduct = filteredProducts[indexPath.row]
            print("Selected product: \(selectedProduct)") // Handle product selection action
            searchBar.text = selectedProduct // Set the search bar text to the selected product
            searchBar.resignFirstResponder()
            dropdownTableView.isHidden = true
            isDropdownVisible = false
        }
    }
}
