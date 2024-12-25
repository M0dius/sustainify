//
//  LoginViewController.swift
//  Sustainify
//
//  Created by Guest User on 25/12/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            guard error == nil else {
                // Display error message from Firebase in the alert
                let alert = UIAlertController(
                    title: "Invalid credentials",
                    message: "Invalid credentials, Please try again. Error: \(error?.localizedDescription ?? "Unknown error")",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(alert, animated: true)
                
                return
            }
            
            // If no error, perform segue
            self.performSegue(withIdentifier: "test", sender: sender)
        }
    }


    @IBAction func signout(_ sender: UIButton) {
        do{
            try FirebaseAuth.Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Error signing out")
        }
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
