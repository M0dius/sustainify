//
//  settingsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 08/12/2024.
//

import UIKit
import FirebaseAuth

class settingsTableViewController: UITableViewController {

    // Define the sections and rows for the table
    let settingsOptions = [
        "Profile",
        "Preferences",
        "Reviews",
        "Booked Items",
        "Vouchers",
        "About Us",
        "Sign Out"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for all settings
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }

    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        return cell
    }

    // MARK: - Table View Delegate

    // Handle row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Navigate to the appropriate screen based on the selected option
        switch settingsOptions[indexPath.row] {
        case "Profile":
            navigateToProfile()
        case "Preferences":
            navigateToPreferences()
        case "Reviews":
            navigateToReviews()
        case "Booked Items":
            navigateToBookedItems()
        case "Vouchers":
            navigateToVouchers()
        case "About Us":
            navigateToAboutUs()
        case "Sign Out":
            signOut()
        default:
            break
        }
    }

    // MARK: - Navigation Methods

    func navigateToProfile() {
        // Perform segue to Profile screen
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }

    func navigateToPreferences() {
        // Perform segue to Preferences screen
        performSegue(withIdentifier: "PreferencesSegue", sender: self)
    }

    func navigateToReviews() {
        // Perform segue to Reviews screen
        performSegue(withIdentifier: "ReviewsSegue", sender: self)
    }

    func navigateToBookedItems() {
        // Perform segue to Booked Items screen
        performSegue(withIdentifier: "BookedItemsSegue", sender: self)
    }

    func navigateToVouchers() {
        // Perform segue to Vouchers screen
        performSegue(withIdentifier: "VouchersSegue", sender: self)
    }

    func navigateToAboutUs() {
        // Perform segue to About Us screen
        performSegue(withIdentifier: "AboutUsSegue", sender: self)
    }
    
    func signOut() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        // Add the "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add the "Sign Out" action
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("Error signing out")
                let errorAlert = UIAlertController(
                    title: "Error",
                    message: "An error occurred while signing out. Please try again.",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
            }
        }))
        
        // Present the alert
        present(alert, animated: true)
    }

}
