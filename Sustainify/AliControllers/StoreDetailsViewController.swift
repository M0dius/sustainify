import UIKit

class StoreDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var store: Store? // Store object passed from HomeViewController
        var items: [String] = [] // Items to display in the table view

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set the navigation title to the store's name
            if let store = store {
                self.title = store.name
            }

            setupSearchBar()
            setupTableView()

            // Populate items if store is available
            if let store = store {
                items = store.items
            }
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

            // Register custom cell
            tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: "storeInfoCell")
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "storeDetailCell")
        }

        // MARK: - Table View Data Source

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count + 1 // Additional row for the store info cell
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                // Configure the store info cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "storeInfoCell", for: indexPath) as! StoreInfoTableViewCell
                if let store = store {
                    cell.configure(with: store)
                }
                return cell
            } else {
                // Configure the product cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "storeDetailCell", for: indexPath)
                cell.textLabel?.text = items[indexPath.row - 1]
                return cell
            }
        }
    }
