//
//  AddressListViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

//
//  AddressListViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit
import FirebaseFirestore

class AddressListViewController: UITableViewController {

    @IBOutlet weak var addAddress: UIBarButtonItem!
    @IBOutlet weak var deleteAddress: UIBarButtonItem!

    var addresses: [Address] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Addresses"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        // Fetch the addresses from Firestore
        fetchAddresses()
        
        // Add a navigation bar "Add Address" button
        navigationItem.rightBarButtonItem = addAddress
    }

    // Fetch addresses from Firestore
    func fetchAddresses() {
        db.collection("Addresses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching addresses: \(error)")
            } else {
                self.addresses = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    
                    // Extract address data from Firestore document
                    let addressTitle = data["title"] as? String ?? ""
                    let addressType = data["addressType"] as? String ?? ""
                    let house = data["house"] as? Int ?? 0
                    let block = data["block"] as? Int ?? 0
                    let road = data["road"] as? Int ?? 0
                    let phoneNumber = data["phoneNumber"] as? Int ?? 0
                    let apartmentNumber = data["apartmentNumber"] as? Int ?? 0
                    let building = data["building"] as? Int ?? 0
                    let floor = data["floor"] as? Int ?? 0
                    let company = data["company"] as? String ?? ""
                    let officeNumber = data["officeNumber"] as? Int ?? 0
                    
                    // Return an Address object
                    return Address(
                        id: document.documentID,
                        address: addressTitle,
                        addressType: addressType,
                        house: house,
                        block: block,
                        road: road,
                        phoneNumber: phoneNumber,
                        apartmentNumber: apartmentNumber,
                        building: building,
                        floor: floor,
                        company: company,
                        officeNumber: officeNumber
                    )
                } ?? []
                self.tableView.reloadData()
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
        
        // Optionally, clear other elements of the cell, if necessary
        cell.detailTextLabel?.text = nil  // Make sure no other text is shown
        
        return cell
    }

    // MARK: - Swipe to Delete Action

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Define delete action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "-") { _, indexPath in
            self.deleteAddress(at: indexPath)
        }
        return [deleteAction]
    }

    // Delete address from Firestore
    func deleteAddress(at indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        
        // Delete address from Firestore
        db.collection("Addresses").document(address.id).delete { error in
            if let error = error {
                print("Error deleting address: \(error)")
            } else {
                // Remove address from local array and update the table view
                self.addresses.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - Add Address Button Action

    @IBAction func addAddressBtn(_ sender: Any) {
        // Perform segue to Add Address screen
        performSegue(withIdentifier: "addAddressSegue", sender: nil)
    }

    // MARK: - Delete Address Button Action

    @IBAction func deleteAddressBtn(_ sender: Any) {
        // Delete all selected addresses (or show confirmation to delete multiple)
        let selectedRows = tableView.indexPathsForSelectedRows
        guard let rows = selectedRows else { return }
        
        for indexPath in rows {
            let address = addresses[indexPath.row]
            db.collection("Addresses").document(address.id).delete { error in
                if let error = error {
                    print("Error deleting address: \(error)")
                } else {
                    self.addresses.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    // Prepare for segue to add address
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addAddressSegue", let addVC = segue.destination as? AddAddressViewController {
            // No need to pass any data for adding a new address
        }
    }
}
