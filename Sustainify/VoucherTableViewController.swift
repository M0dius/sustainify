//
//  VoucherTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 30/12/2024.
//

import UIKit
import FirebaseFirestore

class VoucherTableViewController: UITableViewController {

    @IBOutlet weak var voucherStateSegment: UISegmentedControl!
    @IBOutlet weak var VoucherTable: UITableView!
    
    // Firestore reference
    let db = Firestore.firestore()
    
    // Array to hold the vouchers
    var vouchers = [Voucher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load "Active" vouchers by default when the page is first opened
        fetchVouchers(status: "Active")
    }

    // MARK: - Segmented Control Action
    @IBAction func voucherStateChanged(_ sender: UISegmentedControl) {
        // Fetch vouchers based on the selected status
        let status = sender.selectedSegmentIndex == 0 ? "Active" : "Disabled"
        fetchVouchers(status: status)
    }
    
    // MARK: - Fetch Vouchers
    func fetchVouchers(status: String) {
        db.collection("Vouchers")
            .whereField("status", isEqualTo: status)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting vouchers: \(error.localizedDescription)")
                    return
                }
                
                // Parse the snapshot data and reload the table
                self.vouchers = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return Voucher(
                        code: data["code"] as? String ?? "",
                        discount: data["discount"] as? Int ?? 0,
                        expiryDate: data["expiryDate"] as? String ?? "",
                        status: data["status"] as? String ?? ""
                    )
                } ?? []
                
                self.tableView.reloadData()  // Reload table with the fetched data
            }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1  // Assuming one section for vouchers
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers.count  // Return number of vouchers based on fetched data
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell to display voucher information
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherCell", for: indexPath)
        let voucher = vouchers[indexPath.row]
        
        // Set up your cell UI based on voucher data
        cell.textLabel?.text = voucher.code
        cell.detailTextLabel?.text = "Discount: \(voucher.discount)% - Expiry: \(voucher.expiryDate)"
        
        return cell
    }
}
