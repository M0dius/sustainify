import Foundation
import UIKit

// Define a simple User struct
struct User {
    var username: String
    var email: String
    var userType: String
}

class UserListViewController: UITableViewController, AddUserDelegate {
    
    // Array to hold the users
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        
        // Set the username as the title (textLabel)
        cell.textLabel?.text = user.username
        
        // Set the user type as the subtitle (detailTextLabel)
        cell.detailTextLabel?.text = user.userType
        
        return cell
    }
    
    // AddUserDelegate method
    func didAddUser(username: String, email: String, userType: String) {
        // Create a new user and append it to the users array
        let newUser = User(username: username, email: email, userType: userType)
        users.append(newUser)
        
        // Reload the table view to show the new user
        tableView.reloadData()
    }
    
    // Method to present AddUserViewController
    @IBAction func showAddUserScreen(_ sender: UIBarButtonItem) {
        let addUserVC = storyboard?.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        addUserVC.delegate = self
        present(addUserVC, animated: true, completion: nil)
    }
}

