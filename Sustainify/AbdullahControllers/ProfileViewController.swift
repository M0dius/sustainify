//
//  ProfileViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    var db: Firestore!
    var currentUser: FirebaseAuth.User!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnEditAccount: UIButton!
    @IBOutlet weak var btnSaveChanges: UIButton!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    var originalUsername: String?
    var originalEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        // Ensure the user is logged in
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }
        
        currentUser = user
        
        fetchUserData()
        
        // Disable text fields for the initial state
        txtUsername.isEnabled = false
        txtEmail.isEnabled = false // Email stays disabled
        
        txtEmail.isSecureTextEntry = false // Make email visible
        
        // Initially hide the Save Changes and Delete Account buttons
        btnSaveChanges.isHidden = true
        btnDeleteAccount.isHidden = true
    }

    @IBAction func btnEditAccount(_ sender: UIButton) {
        // Enable only the username text field for editing
        txtUsername.isEnabled = true
        
        // Disable the Edit button and show Save Changes and Delete Account buttons
        sender.isEnabled = false // Disable Edit button
        btnSaveChanges.isHidden = false // Show Save Changes button
        btnDeleteAccount.isHidden = false // Show Delete Account button
    }
    
    @IBAction func btnSaveChanges(_ sender: UIButton) {
        // Check if the username or email has changed before showing an alert
        let updatedUsername = txtUsername.text ?? ""
        let updatedEmail = txtEmail.text ?? ""
        
        // If no changes are made, reset UI to initial state and return
        if updatedUsername == originalUsername && updatedEmail == originalEmail {
            // No changes, so reset UI
            resetUIToInitialState()
            return
        }
        
        // Show confirmation alert before saving changes
        let alert = UIAlertController(title: "Confirm Changes", message: "Are you sure you want to save the changes?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            // Save the user data
            self.saveUserData()
            
            // Reset UI after saving
            self.resetUIToInitialState()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func resetUIToInitialState() {
        // Disable text fields after saving
        txtUsername.isEnabled = false
        txtEmail.isEnabled = false // Keep email disabled
        
        // Hide the Save Changes button and Delete Account button
        btnSaveChanges.isHidden = true
        btnDeleteAccount.isHidden = true
        
        // Enable the Edit button
        btnEditAccount.isEnabled = true
    }

    
    @IBAction func btnDeleteAccount(_ sender: UIButton) {
        // Show confirmation alert before deleting account
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Delete the user account
            self.deleteUserAccount()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchUserData() {
        // Populate email directly from Firebase Authentication
        guard let user = currentUser else { return }
        
        txtEmail.text = user.email
        
        // Fetch username from Firestore "users" collection
        db.collection("users").document(user.uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user data from Firestore: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                // Populate the text fields with the current user data
                let data = document.data()
                self?.txtUsername.text = data?["username"] as? String
                // Save original values for comparison
                self?.originalUsername = self?.txtUsername.text
                self?.originalEmail = self?.txtEmail.text
            } else {
                print("User document does not exist")
            }
        }
    }

    func saveUserData() {
        guard let user = currentUser else { return }
        
        let updatedUsername = txtUsername.text ?? ""
        let updatedEmail = txtEmail.text ?? ""
        
        // 1. Update the email in Firebase Authentication (if changed)
        /*if updatedEmail != user.email {
            updateEmail(updatedEmail) // Call the function to update email in Firebase Authentication
        }*/
        
        // 2. Update the username in Firestore (if changed)
        if updatedUsername != originalUsername {
            db.collection("users").document(user.uid).updateData([
                "username": updatedUsername
            ]) { error in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                } else {
                    print("Username updated successfully in Firestore")
                }
            }
        }
    }

    /*func updateEmail(_ updatedEmail: String) {
        guard let user = currentUser else { return }
        
        // Update the email in Firebase Authentication (requires re-authentication if email was recently changed)
        user.updateEmail(to: updatedEmail) { error in
            if let error = error {
                print("Error updating email in Firebase Authentication: \(error.localizedDescription)")
                return
            }
            
            // After updating email, send a verification email
            user.sendEmailVerification { error in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                    return
                }
                print("Verification email sent successfully to \(updatedEmail). Please verify the email before updating.")
                
                // Optionally, you can show a message to the user indicating that they need to verify their email
                let alert = UIAlertController(title: "Email Verification", message: "A verification email has been sent to \(updatedEmail). Please verify your email before the changes take effect.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }*/

    func deleteUserAccount() {
        guard let user = currentUser else { return }
        
        // Delete the user account from Firebase Authentication first
        user.delete { [weak self] error in
            if let error = error {
                print("Error deleting user account from Firebase Authentication: \(error.localizedDescription)")
                return
            }
            
            // After the Firebase Authentication account is deleted, delete the user document from Firestore
            self?.db.collection("users").document(user.uid).delete { error in
                if let error = error {
                    print("Error deleting user document from Firestore: \(error.localizedDescription)")
                } else {
                    print("User document deleted successfully from Firestore")
                }
                
                // Log out the user after account deletion
                do {
                    try Auth.auth().signOut()
                    // Navigate to the login screen
                    self?.navigateToLoginScreen()
                } catch let signOutError {
                    print("Error signing out: \(signOutError.localizedDescription)")
                }
            }
        }
    }

    // Navigate to the login screen
    func navigateToLoginScreen() {
        // Assuming you are using a UINavigationController
        if let navigationController = self.navigationController {
            // Perform the segue to the login screen
            navigationController.popToRootViewController(animated: true)
        } else {
            // If not using navigation controller, you can use the following
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(loginVC!, animated: true, completion: nil)
        }
    }
}
