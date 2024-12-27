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
        txtEmail.isEnabled = false
        
        txtEmail.isSecureTextEntry = false // Make email visible
        
        // Initially hide the Save Changes and Delete Account buttons
        btnSaveChanges.isHidden = true
        btnDeleteAccount.isHidden = true
    }

    @IBAction func btnEditAccount(_ sender: UIButton) {
        // Enable text fields for editing
        txtUsername.isEnabled = true
        txtEmail.isEnabled = true
        
        // Disable the Edit button and show Save Changes and Delete Account buttons
        sender.isEnabled = false // Disable Edit button
        btnSaveChanges.isHidden = false // Show Save Changes button
        btnDeleteAccount.isHidden = false // Show Delete Account button
    }
    
    @IBAction func btnSaveChanges(_ sender: UIButton) {
        // Show confirmation alert before saving changes
        let alert = UIAlertController(title: "Confirm Changes", message: "Are you sure you want to save the changes?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            // Save the user data
            self.saveUserData()
            
            // Disable text fields after saving
            self.txtUsername.isEnabled = false
            self.txtEmail.isEnabled = false
            
            // Hide the Save Changes button and enable the Edit button
            self.btnSaveChanges.isHidden = true
            self.btnDeleteAccount.isHidden = true // Hide the Delete Account button again
            self.btnEditAccount.isEnabled = true // Enable Edit button again
        }))
        
        self.present(alert, animated: true, completion: nil)
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
            } else {
                print("User document does not exist")
            }
        }
    }

    // Save the user data to Firestore and Firebase Authentication
    func saveUserData() {
        guard let user = currentUser else { return }
        
        let updatedUsername = txtUsername.text ?? ""
        let updatedEmail = txtEmail.text ?? ""
        
        // 1. Update the email in Firebase Authentication (deprecation warning)
        if updatedEmail != user.email {
            updateEmail(updatedEmail) // Custom function to handle email update
        }
        
        // 2. Update the username in Firestore
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
    
    func updateEmail(_ updatedEmail: String) {
        guard let user = currentUser else { return }
        
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
                return
            }
            print("Verification email sent successfully to \(updatedEmail). Please verify the email before updating.")
        }
        
        // Actual email update should be done after the user verifies the email.
    }

    func deleteUserAccount() {
        guard let user = currentUser else { return }
        
        // Delete the user document from Firestore
        db.collection("users").document(user.uid).delete { error in
            if let error = error {
                print("Error deleting user document: \(error.localizedDescription)")
            } else {
                print("User document deleted successfully from Firestore")
            }
        }
        
        // Delete the user account from Firebase Authentication
        user.delete { [weak self] error in
            if let error = error {
                print("Error deleting user account: \(error.localizedDescription)")
            } else {
                print("User account deleted successfully")
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
