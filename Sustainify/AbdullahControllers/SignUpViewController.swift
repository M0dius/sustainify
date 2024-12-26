//
//  SignUpViewController.swift
//  Sustainify
//
//  Created by Guest User on 26/12/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    // Firestore reference
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }

    // MARK: - Sign-Up Action
    @IBAction func btnSignUp(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let confirmPassword = txtPasswordConfirm.text, !confirmPassword.isEmpty,
              let username = txtUsername.text, !username.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        // Validate passwords match
        if password != confirmPassword {
            showAlert(message: "Passwords do not match.")
            return
        }

        // Create user with Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: "Sign-up failed: \(error.localizedDescription)")
                return
            }

            // Store additional user data in Firestore
            if let userId = authResult?.user.uid {
                self.db.collection("users").document(userId).setData([
                    "username": username,
                    "email": email,
                    "createdAt": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        self.showAlert(message: "Failed to save user data: \(error.localizedDescription)")
                    } else {
                        self.showAlert(message: "Sign-up successful!", isSuccess: true)
                    }
                }
            }
        }
    }

    // MARK: - Helper Functions
    private func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "Success" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if isSuccess {
                // Navigate to another screen or reset the form
                self.clearFields()
            }
        }))
        present(alert, animated: true)
    }

    private func clearFields() {
        txtEmail.text = ""
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        txtUsername.text = ""
    }
}
