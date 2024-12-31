//
//  AboutUsViewController.swift
//  Sustainify
//
//  Created by Guest User on 26/12/2024.
//

import UIKit

class AboutUsViewController: UITableViewController {

    // Array of links and corresponding titles
    let aboutUsOptions = [
        ("Website", "https://www.wix.com"),
        ("X (Twitter)", "https://x.com"),
        ("Facebook", "https://www.facebook.com"),
        ("YouTube", "https://www.youtube.com"),
        ("Instagram", "https://www.instagram.com")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the screen
        self.title = "Contact"
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Only one section for all about us links
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutUsOptions.count
    }

    // Configure each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        let (title, _) = aboutUsOptions[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }

    // MARK: - Table View Delegate

    // Handle row selection and open the URL in Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the link associated with the selected title
        let (_, urlString) = aboutUsOptions[indexPath.row]
        
        if let url = URL(string: urlString) {
            // Open the URL in Safari
            UIApplication.shared.open(url)
        }
    }
}
