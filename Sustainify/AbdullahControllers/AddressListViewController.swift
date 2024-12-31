//
//  AddressListViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddressListViewController: UITableViewController {

    @IBOutlet weak var addAddress: UIBarButtonItem!
    @IBOutlet weak var deleteAddress: UIBarButtonItem!
    @IBOutlet weak var btnrefresh: UIBarButtonItem!

    var addresses: [Address] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Addresses"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        // Fetch the addresses for the currently logged-in user
        fetchAddresses()

        // Add a navigation bar "Add Address" button
        navigationItem.rightBarButtonItem = addAddress
    }

    // Fetch addresses from Firestore for the currently logged-in user
    func fetchAddresses() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }

        db.collection("Addresses")
            .whereField("userID", isEqualTo: userID) // Filter by userID
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching addresses: \(error)")
                } else {
                    self?.addresses = snapshot?.documents.compactMap { document in
                        let data = document.data()

                        // Extract address data from Firestore document
                        return Address(
                            id: document.documentID,
                            address: data["address"] as? String ?? "",
                            addressType: data["addressType"] as? String ?? "",
                            house: data["house"] as? Int ?? 0,
                            block: data["block"] as? Int ?? 0,
                            road: data["road"] as? Int ?? 0,
                            phoneNumber: data["phoneNumber"] as? Int ?? 0,
                            apartmentNumber: data["apartmentNumber"] as? Int ?? 0,
                            building: data["building"] as? Int ?? 0,
                            floor: data["floor"] as? Int ?? 0,
                            company: data["company"] as? String ?? "",
                            officeNumber: data["officeNumber"] as? Int ?? 0
                        )
                    } ?? []
                    self?.tableView.reloadData()
                }
            }
    }

    // MARK: - Table View Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath)
        
        // Get the address for the current row
        let address = addresses[indexPath.row]
        
        // Set the title for the cell (only the title)
        cell.textLabel?.text = address.address
        
        return cell
    }

    // MARK: - Swipe to Delete Action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            // Show confirmation alert before deleting
            let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this address?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self?.deleteAddress(at: indexPath)
            }))
            
            self?.present(alert, animated: true, completion: nil)
            
            completionHandler(true)  // Must call completionHandler
        }
        
        // Return the swipe actions configuration with the delete action
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }

    // Delete address from Firestore
    func deleteAddress(at indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        
        // Delete address from Firestore
        db.collection("Addresses").document(address.id).delete { [weak self] error in
            if let error = error {
                print("Error deleting address: \(error)")
            } else {
                // Remove address from local array and update the table view
                self?.addresses.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - Add Address Button Action

    @IBAction func addAddressBtn(_ sender: Any) {
        // Perform segue to Add Address screen
        performSegue(withIdentifier: "addAddressSegue", sender: nil)
    }

    // MARK: - Row Selection (Trigger Edit Address Segue)

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected address
        let selectedAddress = addresses[indexPath.row]

        // Perform the segue to the Edit Address screen
        performSegue(withIdentifier: "editAddressSegue", sender: selectedAddress)
    }

    // MARK: - Prepare for Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAddressSegue", let editVC = segue.destination as? EditAddressViewController {
            // Pass the selected address ID to the EditAddressViewController
            if let address = sender as? Address {
                editVC.addressID = address.id
            }
        }
    }

    // MARK: - Refresh Button Action

    @IBAction func refreshAddresses(_ sender: UIBarButtonItem) {
        // Reload the addresses from Firestore
        fetchAddresses()
    }
}
