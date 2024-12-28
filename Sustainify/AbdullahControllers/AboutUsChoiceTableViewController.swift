//
//  AboutUsChoiceTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 28/12/2024.
//

//
//  AboutUsChoiceTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 28/12/2024.
//

import UIKit

class AboutUsChoiceTableViewController: UITableViewController {

    // Data for the table view
    let aboutUsOptions = ["FAQ", "Contact"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title for the navigation bar
        self.title = "About Us"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section is needed
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows corresponds to the number of items in `aboutUsOptions`
        return aboutUsOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create or reuse a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath)

        // Set the text for the cell based on the `aboutUsOptions` array
        cell.textLabel?.text = aboutUsOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator // Add a ">" arrow to indicate navigation

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after it's tapped
        tableView.deselectRow(at: indexPath, animated: true)

        // Perform the segue based on the selected row
        switch indexPath.row {
        case 0: // FAQ
            performSegue(withIdentifier: "FAQSegue", sender: self)
        case 1: // Contact
            performSegue(withIdentifier: "ContactSegue", sender: self)
        default:
            break
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Customize segue behavior if needed
        if segue.identifier == "FAQSegue" {
            // Example: Set the title for the FAQ page
            if let destinationVC = segue.destination as? FAQViewController {
                destinationVC.title = "FAQ"
            }
        } else if segue.identifier == "ContactSegue" {
            // Example: Set the title for the Contact page
            if let destinationVC = segue.destination as? ContactViewController {
                destinationVC.title = "Contact Us"
            }
        }
    }
}
