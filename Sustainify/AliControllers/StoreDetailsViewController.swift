import UIKit

class StoreDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var store: Store? // Store object passed from HomeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the navigation title to the store's name
        if let store = store {
            self.title = store.name
        }
        
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar() {
        let searchBar = UISearchBar()
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
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Only one cell for the store info
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath) as! StoreInfoTableViewCell
        if let store = store {
            cell.configure(with: store)
        }
        return cell
    }
}
