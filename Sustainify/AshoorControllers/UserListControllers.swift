import UIKit

class UserListControllers: UITableViewController {
    
    // Array to store users
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.userName  // Title
        cell.detailTextLabel?.text = user.userType  // Subtitle
        
        return cell
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    // MARK: - Delete User
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Row Selection for Editing
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // No manual segue here. The storyboard segue will handle navigation.
    }
    
    // MARK: - Unwind Segue Method
    
    @IBAction func unwindToUserList(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddingUserControllers, let newUser = sourceVC.newUser {
            users.append(newUser)
            tableView.reloadData()
            showAlert(title: "User Added", message: "The user has been added successfully.")
        } else if let sourceVC = segue.source as? EditUserController, let updatedUser = sourceVC.updatedUser, let index = sourceVC.userIndex {
            users[index] = updatedUser
            tableView.reloadData()
            showAlert(title: "User Updated", message: "The user details have been updated successfully.")
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditUser", let destinationVC = segue.destination as? EditUserController, let indexPath = tableView.indexPathForSelectedRow {
            let user = users[indexPath.row]
            destinationVC.userToEdit = user
            destinationVC.userIndex = indexPath.row
        }
    }
    
    // MARK: - Utility Methods
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
