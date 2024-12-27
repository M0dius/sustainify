//
//  ProfAddressTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit

class ProfAddressTableViewController: UITableViewController {
    
    // Section and row identifiers
    private enum Section: Int, CaseIterable {
        case profile
        case addresses
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile/Addresses"
        
        // Register a basic UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // We have two sections: Profile and Addresses
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each section has 1 row
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Titles for each section
        switch Section(rawValue: section) {
        case .profile:
            return "Profile"
        case .addresses:
            return "Addresses"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell based on the section
        switch Section(rawValue: indexPath.section) {
        case .profile:
            cell.textLabel?.text = "Profile"
            cell.accessoryType = .disclosureIndicator
        case .addresses:
            cell.textLabel?.text = "Addresses"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection and navigate to appropriate screen
        switch Section(rawValue: indexPath.section) {
        case .profile:
            performSegue(withIdentifier: "AccountInfo", sender: self)
        case .addresses:
            performSegue(withIdentifier: "AddressesList", sender: self)
        default:
            break
        }
        
        // Deselect the row after selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Handle preparation before navigation if needed
        if segue.identifier == "AccountInfo" {
            // Pass data to AccountInfo view controller (if necessary)
        } else if segue.identifier == "AddressesList" {
            // Pass data to AddressesList view controller (if necessary)
        }
    }*/
}
