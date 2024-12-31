//
//  VouchersTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//

import UIKit
import FirebaseFirestore

// MARK: - Voucher Model
struct Voucher {
    let code: String
    let discount: Double
    let expiryDate: String
    let status: String
}

class VouchersTableViewController: UITableViewController {

    // Firestore reference
    let db = Firestore.firestore()
    
    // Arrays to hold vouchers for each section
    var enabledVouchers = [Voucher]()
    var disabledVouchers = [Voucher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch vouchers when the view loads
        fetchVouchers()
    }

    // MARK: - Fetch Vouchers
    func fetchVouchers() {
        db.collection("Vouchers").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching vouchers: \(error.localizedDescription)")
                return
            }
            
            // Clear existing data
            self.enabledVouchers.removeAll()
            self.disabledVouchers.removeAll()
            
            // Parse the snapshot data
            for document in snapshot?.documents ?? [] {
                let data = document.data()
                if let code = data["code"] as? String,
                   let discount = data["discount"] as? Double,
                   let expiryDate = data["expiryDate"] as? String,
                   let status = data["status"] as? String {
                    let voucher = Voucher(code: code, discount: discount, expiryDate: expiryDate, status: status)
                    
                    // Add to the appropriate section
                    if status == "Active" {
                        self.enabledVouchers.append(voucher)
                    } else if status == "Disabled" {
                        self.disabledVouchers.append(voucher)
                    }
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
        return 2 // One section for Enabled and one for Disabled vouchers
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return enabledVouchers.count
        } else {
            return disabledVouchers.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Enabled Vouchers" : "Disabled Vouchers"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath)
        
        // Determine the voucher based on the section
        let voucher: Voucher
        if indexPath.section == 0 {
            voucher = enabledVouchers[indexPath.row]
        } else {
            voucher = disabledVouchers[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel?.text = voucher.code
        cell.detailTextLabel?.text = "Discount: \(voucher.discount)% - Expiry: \(voucher.expiryDate)"
        
        return cell
    }

    // Optional: Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let voucher: Voucher
        if indexPath.section == 0 {
            voucher = enabledVouchers[indexPath.row]
        } else {
            voucher = disabledVouchers[indexPath.row]
        }
        print("Selected Voucher: \(voucher.code)")
    }
}
