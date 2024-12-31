import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController,
                          UISearchBarDelegate,
                          UITableViewDataSource,
                          UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: "storeCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        loadStoreData()
    }

    // MARK: - Load Data
    private func loadStoreData() {
        fetchStoresFromFirestore { [weak self] firebaseStores in
            guard let self = self else { return }
            
            let hardcodedStores = DataManager.shared.stores
            self.allStores = firebaseStores + hardcodedStores
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Fetch from Firestore
    private func fetchStoresFromFirestore(completion: @escaping ([Store]) -> Void) {
        let db = Firestore.firestore()

        db.collection("Stores").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching stores: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let storeDocuments = snapshot?.documents else {
                print("No documents in the 'Stores' collection.")
                completion([])
                return
            }

            var fetchedStores: [Store] = []
            for storeDoc in storeDocuments {
                let data = storeDoc.data()

                let name = data["name"] as? String ?? "Unnamed Store"
                let description = data["description"] as? String ?? "No Description"
                let openingTime = data["openingTime"] as? String ?? "N/A"
                let closingTime = data["closingTime"] as? String ?? "N/A"
                let imageName = data["imageName"] as? String ?? "StoreIcon"
                let store = Store(
                    name: name,
                    detail: description,
                    imageName: imageName,
                    openingTime: openingTime,
                    closingTime: closingTime,
                    allStoreItems: []
                )

                fetchedStores.append(store)
            }

            db.collection("Products").getDocuments { (productSnapshot, productError) in
                if let productError = productError {
                    print("Error fetching products: \(productError.localizedDescription)")
                    completion([])
                    return
                }

                guard let productDocuments = productSnapshot?.documents else {
                    print("No products found in the 'Products' collection.")
                    completion(fetchedStores)
                    return
                }

                var allProducts: [StoreItem] = []

                for productDoc in productDocuments {
                    let productData = productDoc.data()

                    let name = productData["name"] as? String ?? "Unknown Product"
                    let price = "$\(productData["price"] as? Double ?? 0.0)"
                    let imageName = productData["imageName"] as? String ?? "PlaceholderImage"
                    let category = productData["category"] as? String ?? "Uncategorized"
                    let co2Emissions = productData["ecoScore"] as? Double ?? 0.0
                    let recyclability = 0.0
                    let plasticWaste = 0.0

                    let product = StoreItem(
                        name: name,
                        price: price,
                        imageName: imageName,
                        category: category,
                        co2Emissions: co2Emissions,
                        recyclability: recyclability,
                        plasticWaste: plasticWaste
                    )
                    allProducts.append(product)
                }

                fetchedStores = fetchedStores.map { store in
                    return Store(
                        name: store.name,
                        detail: store.detail,
                        imageName: store.imageName,
                        openingTime: store.openingTime,
                        closingTime: store.closingTime,
                        allStoreItems: allProducts
                    )
                }
                completion(fetchedStores)
            }
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredStores.count : allStores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "storeCell",
            for: indexPath
        ) as! StoreTableViewCell
        
        let store = isSearching ? filteredStores[indexPath.row] : allStores[indexPath.row]
        cell.configure(with: store)
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
