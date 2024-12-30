//
//  ListOfStoresTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

import UIKit
import Firebase

class ListOfStoresTableViewController: UITableViewController {
    struct Store {
        let id: String
        let name: String
        let minimumOrder: Int
    }
    
    var stores: [Store] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stores"
        fetchStoresFromFirestore()
    }

    func fetchStoresFromFirestore() {
        let db = Firestore.firestore()
        db.collection("Stores").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching stores: \(error)")
            } else {
                self.stores = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let name = data["name"] as? String ?? "Unknown"
                    let minimumOrder = data["minimumOrder"] as? Int ?? 0
                    return Store(id: document.documentID, name: name, minimumOrder: minimumOrder)
                } ?? []
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath)
        let store = stores[indexPath.row]
        cell.textLabel?.text = store.name
        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStore = stores[indexPath.row]
        performSegue(withIdentifier: "showProducts", sender: selectedStore)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProducts",
           let indexPath = tableView.indexPathForSelectedRow,
           let destinationVC = segue.destination as? ListOfProductsTableViewController {
            let selectedStore = stores[indexPath.row]
            destinationVC.storeID = selectedStore.id
        }
    }

}
