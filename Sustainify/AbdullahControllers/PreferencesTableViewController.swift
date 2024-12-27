//
//  PreferencesTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.


import UIKit

class PreferencesTableViewController: UITableViewController {

    // Array to hold the settings options
    let preferences = [
        "Light/Dark Mode",
        "Notifications",
        "Favourite Address",
        "Favourite Card"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cells if using them in code (not storyboard prototypes)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LightDarkCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavouriteAddress")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavouriteCard")
        
        // Optionally, preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // We only have one section of preferences
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferences.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell based on the setting
        let setting = preferences[indexPath.row]
        var cell: UITableViewCell
        
        switch setting {
        case "Light/Dark Mode":
            cell = tableView.dequeueReusableCell(withIdentifier: "LightDarkCell", for: indexPath)
            // Add a switch for Light/Dark Mode
            let switchControl = UISwitch()
            switchControl.isOn = UserDefaults.standard.bool(forKey: "lightDarkModeEnabled")
            switchControl.addTarget(self, action: #selector(toggleAppearanceMode(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
        case "Notifications":
            cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath)
            // Add a switch for Notifications
            let switchControl = UISwitch()
            switchControl.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
            switchControl.addTarget(self, action: #selector(toggleNotifications(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
        case "Favourite Address":
            cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteAddress", for: indexPath)
            // Add a dropdown button for Favourite Address
            let dropdownButton = UIButton(type: .system)
            dropdownButton.setTitle("Select Address", for: .normal)
            dropdownButton.addTarget(self, action: #selector(showAddressDropdown(_:)), for: .touchUpInside)
            cell.accessoryView = dropdownButton
        case "Favourite Card":
            cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCard", for: indexPath)
            // Add a dropdown button for Favourite Card
            let dropdownButton = UIButton(type: .system)
            dropdownButton.setTitle("Select Card", for: .normal)
            dropdownButton.addTarget(self, action: #selector(showCardDropdown(_:)), for: .touchUpInside)
            cell.accessoryView = dropdownButton
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
        
        // Set the label text for each setting
        cell.textLabel?.text = setting
        
        return cell
    }

    // MARK: - Table View Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch preferences[indexPath.row] {
        case "Light/Dark Mode":
            // Handled by the switch in the cell
            break
        case "Notifications":
            break // Handled by the switch in the cell
        case "Favourite Address":
            // Navigate to the Favourite Address screen
            //performSegue(withIdentifier: "FavouriteAddressSegue", sender: self)
            break
        case "Favourite Card":
            // Navigate to the Favourite Card screen
            //performSegue(withIdentifier: "FavouriteCardSegue", sender: self)
            break
        default:
            break
        }
    }

    // MARK: - Helper Methods

    // Toggle between Light and Dark mode
    @objc func toggleAppearanceMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "lightDarkModeEnabled")
        let currentStyle = traitCollection.userInterfaceStyle
        if currentStyle == .dark {
            // Switch to Light Mode
            UIView.appearance().overrideUserInterfaceStyle = .light
        } else {
            // Switch to Dark Mode
            UIView.appearance().overrideUserInterfaceStyle = .dark
        }
        
        // Update the interface immediately after changing appearance
        self.view.window?.rootViewController?.view.setNeedsLayout()
    }

    // Handle the notification toggle switch
    @objc func toggleNotifications(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "notificationsEnabled")
    }

    // Show dropdown for Favourite Address
    @objc func showAddressDropdown(_ sender: UIButton) {
        // Placeholder logic to show a dropdown - you can customize the options here
        print("Showing Address Dropdown")
    }

    // Show dropdown for Favourite Card
    @objc func showCardDropdown(_ sender: UIButton) {
        // Placeholder logic to show a dropdown - you can customize the options here
        print("Showing Card Dropdown")
    }

    // MARK: - Navigation

    // Prepare for segues if necessary to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavouriteAddressSegue" {
            // Pass data to the Favourite Address view controller if needed
        } else if segue.identifier == "FavouriteCardSegue" {
            // Pass data to the Favourite Card view controller if needed
        }
    }
}
