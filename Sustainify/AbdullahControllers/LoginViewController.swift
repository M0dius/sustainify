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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
