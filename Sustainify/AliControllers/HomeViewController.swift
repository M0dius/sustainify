import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController,
                          UISearchBarDelegate,
                          UITableViewDataSource,
                          UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
    // Remove any references to DataManager!
    var allStores = [Store]()
    var filteredStores = [Store]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        
        // Set up search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search stores..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = searchBar
        
        // TableView setup
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // IMPORTANT: Fetch from Firestore
        fetchStoresFromFirestore()
    }

    // MARK: - Fetch from Firestore
    func fetchStoresFromFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Stores").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents in the 'Stores' collection.")
                return
            }
            
            var fetchedStores = [Store]()
            
            for doc in documents {
                let data = doc.data()
                
                // NOTE: rename the fields exactly as in your screenshot:
                let block = data["block"] as? Int ?? 0
                let building = data["building"] as? Int ?? 0
                let crNumber = data["crNumber"] as? Int ?? 0
                let minimumOrder = data["minimumOrder"] as? Int ?? 0
                let name = data["name"] as? String ?? "No Name"
                let road = data["road"] as? Int ?? 0
                let paymentOptions = data["paymentOptions"] as? [String] ?? []
                
                // If your doc also has "openingTime" or "closingTime", fetch them similarly:
                let openingTime = data["openingTime"] as? String ?? "N/A"
                let closingTime = data["closingTime"] as? String ?? "N/A"
                
                // For “detail” or “imageName” we can just put placeholders or retrieve them if stored in Firestore
                let detail = "CR: \(crNumber) | Min Order: \(minimumOrder)"
                let imageName = "PlaceholderImage"
                
                // Create the Store object
                let store = Store(
                    name: name,
                    detail: detail,
                    imageName: imageName,
                    openingTime: openingTime,
                    closingTime: closingTime,
                    allStoreItems: [] // We'll fill this if you eventually want product items in Firestore
                )
                
                fetchedStores.append(store)
            }
            
            // Assign to our arrays
            self.allStores = fetchedStores
            // If you want the search bar to also search them immediately:
            // self.filteredStores = fetchedStores
            
            // Reload the table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredStores.count : allStores.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "storeCell",
            for: indexPath
        ) as! StoreTableViewCell
        
        let store = isSearching ? filteredStores[indexPath.row] : allStores[indexPath.row]
        cell.configure(with: store)
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showStoreDetails", sender: indexPath)
    }

    // MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStores = allStores.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        isSearching = !searchText.isEmpty
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoreDetails",
           let destinationVC = segue.destination as? StoreDetailsViewController,
           let indexPath = sender as? IndexPath {
            let selectedStore = isSearching ? filteredStores[indexPath.row] : allStores[indexPath.row]
            destinationVC.store = selectedStore
        }
    }
}
