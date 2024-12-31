//
//  OrderHistoryTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//

// OrderHistoryTableViewController.swift
// Sustainify

import UIKit
import FirebaseFirestore

class OrderHistoryTableViewController: UITableViewController {

    // Firestore reference
    let db = Firestore.firestore()
    
    // Array to store orders
    var orders = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch orders when the view loads
        fetchOrders()
        
        // Enable dynamic cell resizing
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120 // Adjusted for better readability
    }

    // MARK: - Fetch Orders
    func fetchOrders() {
        db.collection("Orders").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                return
            }
            
            // Clear existing data
            self.orders.removeAll()
            
            // Parse the snapshot data
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                if let itemsCount = data["itemsCount"] as? Int,
                   let totalPrice = data["totalPrice"] as? Double,
                   let status = data["status"] as? String {
                    
                    // Create an Order object
                    let order = Order(id: document.documentID, itemsCount: itemsCount, totalPrice: totalPrice, status: status)
                    self.orders.append(order)
                }
            }
            
            // Reload the table view with updated data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Single section for all orders
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as? OrderHistoryTableViewCell else {
            fatalError("Unable to dequeue OrderHistoryCell")
        }
        
        // Get the order for the current row
        let order = orders[indexPath.row]
        
        // Configure the cell with the order data
        cell.configureCell(order: order)
        
        return cell
    }
    
    // Optional: Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOrder = orders[indexPath.row]
        print("Selected Order ID: \(selectedOrder.id)")
    }
}
