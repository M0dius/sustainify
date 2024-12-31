//
//  LoginViewController.swift
//  Sustainify
//
//  Created by Guest User on 25/12/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    private var isLoggingIn = false
    private var isSeguePerformed = false

    @IBOutlet weak var welcomeStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    welcomeStack.translatesAutoresizingMaskIntoConstraints = false
    // Center the stack view horizontally in its superview
    NSLayoutConstraint.activate([
        welcomeStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let username = txtUsername.text, let password = txtPassword.text,
              !username.isEmpty && !password.isEmpty else {
                      
            // Alert for missing fields
            let alert = UIAlertController(
                title: "Missing login field",
                message: "Please fill in the required fields (Username & Password)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
            return
        }
        
        // Prevent multiple login attempts
        guard !isLoggingIn else { return }
        isLoggingIn = true

        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            DispatchQueue.main.async {
                self.isLoggingIn = false // Reset the flag
                
                if let error = error {
                    // Display error message from Firebase in the alert
                    let alert = UIAlertController(
                        title: "Invalid credentials",
                        message: "Invalid credentials, Please try again. Error: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                    return
                }
                
                // Trigger segue manually
                if !self.isSeguePerformed {
                    self.isSeguePerformed = true // Prevent duplicate segues
                    self.performSegue(withIdentifier: "test", sender: sender)
                }
            }
        }
    }


    @IBAction func signout(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSeguePerformed = false // Allow segue to be triggered again
    }
    
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        // Show an alert to enter the email address
        let alert = UIAlertController(title: "Forgot Password", message: "Enter your email address to receive a password reset link.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Email Address"
            textField.keyboardType = .emailAddress
        }
        
        // Add "Send" action to send the reset password request
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                // Call Firebase Authentication to send the password reset email
                FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        // Display error message if the password reset fails
                        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(errorAlert, animated: true)
                    } else {
                        // Notify the user that the reset email has been sent
                        let successAlert = UIAlertController(title: "Success", message: "A password reset link has been sent to your email.", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self.present(successAlert, animated: true)
                    }
                }
            } else {
                // Show alert if email is empty
                let alert = UIAlertController(title: "Missing Email", message: "Please enter a valid email address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }))
        
        // Add "Cancel" action to close the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Show the alert
        self.present(alert, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
