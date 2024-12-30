//
//  ListOfProductsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

import UIKit
import Firebase

class ListOfProductsTableViewController: UITableViewController {
    var storeID: String?
    var products: [(id: String, name: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        fetchProducts()
    }

    func fetchProducts() {
        guard let storeID = storeID else { return }
        let db = Firestore.firestore()
        
        db.collection("Stores").document(storeID).collection("Products").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching products: \(error)")
            } else {
                self.products = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let name = data["name"] as? String ?? "Unnamed Product"
                    return (id: document.documentID, name: name)
                } ?? []
                self.tableView.reloadData()
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
        cell.textLabel?.text = product.name
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails",
           let indexPath = tableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? ProductDetailsViewController {
            let selectedProduct = products[indexPath.row]
            destinationVC.productID = selectedProduct.id
            destinationVC.storeID = storeID
        }
    }
}
