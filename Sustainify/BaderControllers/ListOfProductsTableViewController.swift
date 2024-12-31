//
//  ListOfProductsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

//
//  ListOfProductsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

//
//  ListOfProductsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

//
//  ListOfProductsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

import UIKit
import Firebase

class ListOfProductsTableViewController: UITableViewController {
    var products: [[String: Any]] = [] // Store product data as dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        fetchProducts()
    }

    func fetchProducts() {
        let db = Firestore.firestore()
        
        db.collection("Products").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                self.products = snapshot.documents.compactMap { $0.data() }
                self.tableView.reloadData() // Refresh the table view
                print("Fetched products: \(self.products)")
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        cell.textLabel?.text = product["name"] as? String ?? "Unnamed Product"
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails",
           let indexPath = tableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? ProductDetailsViewController {
            let selectedProduct = products[indexPath.row]
            destinationVC.productDetails = selectedProduct // Pass the product details to the next screen
        }
    }
}
