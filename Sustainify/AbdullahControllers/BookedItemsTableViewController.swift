//
//  BookedItemsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//

import UIKit
import FirebaseFirestore

class BookedItemsTableViewController: UITableViewController {
    
    // Array to hold booked items (initially empty)
    var bookedItems: [BookedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register UITableViewCell for the table
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookedItemCell")
        
        // Fetch booked items data from Firestore
        fetchBookedItems()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookedItems.count // Return the number of booked items
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookedItemCell", for: indexPath)
        
        // Fetch the booked item for this row
        let bookedItem = bookedItems[indexPath.row]
        
        // Set the cell text to the name of the booked item
        cell.textLabel?.text = bookedItem.name
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    // Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = bookedItems[indexPath.row]
        print("Selected item: \(selectedItem.name)")
        // Handle selection if necessary, e.g., navigate to a detail view
    }
    
    // MARK: - Fetching Booked Items from Firestore
    
    func fetchBookedItems() {
        let db = Firestore.firestore()
        
        // Fetch documents from Firestore collection "bookings"
        db.collection("bookings").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)") // If there's an error, log it
                return
            }
            
            // Check if we got documents back
            guard let documents = querySnapshot?.documents else {
                print("No documents found in the 'bookings' collection.")
                return
            }

            print("Fetched \(documents.count) documents.") // Debug: print number of documents

            // Clear previous items and load new data
            self.bookedItems.removeAll()

            // Parse the documents and create BookedItem objects
            for document in documents {
                let data = document.data()
                if let name = data["name"] as? String {
                    let id = document.documentID
                    let bookedItem = BookedItem(name: name, id: id)
                    self.bookedItems.append(bookedItem)
                } else {
                    print("Missing 'name' field in document: \(document.documentID)") // Debugging
                }
            }

            // Debug: Check the number of booked items
            print("Booked items count: \(self.bookedItems.count)")

            // Reload the table with the fetched data
            self.tableView.reloadData()
        }
    }
}
