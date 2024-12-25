import UIKit

class EditUserController: UITableViewController {

    @IBOutlet weak var tUserName: UITextField!
    @IBOutlet weak var tEmail: UITextField!
    @IBOutlet weak var tPassword: UITextField!
    @IBOutlet weak var tConfirmPassword: UITextField!
    @IBOutlet weak var crNumberTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    
    var userToEdit: User?
    var userIndex: Int?
    var updatedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate fields with existing user data
        if let user = userToEdit {
            tUserName.text = user.userName
            tEmail.text = user.email
            tPassword.text = user.password
            tConfirmPassword.text = user.password
            segmentedControl.selectedSegmentIndex = user.userType == "Seller" ? 0 : 1
            crNumberTextField.text = user.crNumber
            updateCRNumberVisibility()
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isFormValid() {
            updatedUser = User(
                userName: tUserName.text!,
                email: tEmail.text!,
                password: tPassword.text!,
                crNumber: segmentedControl.selectedSegmentIndex == 0 ? crNumberTextField.text : nil,
                userType: segmentedControl.selectedSegmentIndex == 0 ? "Seller" : "Buyer"
            )
            self.performSegue(withIdentifier: "unwindToUserList", sender: self)
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please ensure all fields are filled out correctly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func isFormValid() -> Bool {
        return !(tUserName.text?.isEmpty ?? true) &&
               !(tEmail.text?.isEmpty ?? true) &&
               !(tPassword.text?.isEmpty ?? true) &&
               tPassword.text == tConfirmPassword.text &&
               (segmentedControl.selectedSegmentIndex == 1 || !(crNumberTextField.text?.isEmpty ?? true))
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateCRNumberVisibility()
    }

    func updateCRNumberVisibility() {
        crNumberTextField.isHidden = segmentedControl.selectedSegmentIndex != 0
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
}
