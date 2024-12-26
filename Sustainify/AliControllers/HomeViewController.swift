import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
    // Keep these arrays, but remove any hardcoded store creation
    var allStores = [Store]()
    var filteredStores = [Store]()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        searchBar.delegate = self
        searchBar.placeholder = "Search stores..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = searchBar
        
        // 1) DELETE any old code where you did:
        //    allStores = [
        //      Store(name: "IKEA", ...),
        //      Store(name: "Walmart", ...),
        //    ]
        //
        // 2) REPLACE that entire block with this line:
        allStores = DataManager.shared.stores
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register the custom cell
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: "storeCell")
        
        // Layout constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredStores.count : allStores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! StoreTableViewCell
        let store = isSearching ? filteredStores[indexPath.row] : allStores[indexPath.row]
        cell.configure(with: store)
        return cell
    }
    
    // TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showStoreDetails", sender: indexPath)
    }

    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStores = allStores.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        isSearching = !searchText.isEmpty
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetails",
           let destinationVC = segue.destination as? StoreDetailsViewController,
           let indexPath = sender as? IndexPath {
            let selectedStore = isSearching ? filteredStores[indexPath.row] : allStores[indexPath.row]
            destinationVC.store = selectedStore
        }
    }
}
