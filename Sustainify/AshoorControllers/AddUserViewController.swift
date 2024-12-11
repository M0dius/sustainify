//
//  AddUserViewController.swift
//  Sustainify
//
//  Created by Guest User on 08/12/2024.
//

import UIKit

protocol AddUserDelegate: AnyObject {
    func didAddUser(username: String, email: String, userType: String)
}

class AddUserViewController: UITableViewController {
    // Delegate to pass data back
    weak var delegate: AddUserDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var crNumberTextField: UITextField!

    // MARK: - Variables
    var selectedUserType: String?

    // MARK: - Actions
    
    // Action for selecting Seller as the user type
    @IBAction func sellerTapped(_ sender: UIButton) {
        selectedUserType = "Seller"
    }

    // Action for selecting Buyer as the user type
    @IBAction func buyerTapped(_ sender: UIButton) {
        selectedUserType = "Buyer"
    }

    // Action for adding the user
    @IBAction func addUserTapped(_ sender: UIButton) {
        // Validate form inputs
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            print("All fields must be filled")
            return
        }

        guard password == confirmPassword else {
            print("Passwords do not match")
            return
        }

        guard let userType = selectedUserType else {
            print("Please select a user type")
            return
        }

        // Pass data back to the delegate (e.g., UserListViewController)
        delegate?.didAddUser(username: username, email: email, userType: userType)
        
        // Dismiss the AddUserViewController
        dismiss(animated: true, completion: nil)
    }
}

