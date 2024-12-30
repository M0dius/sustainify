import UIKit

class AddingUserControllers: UITableViewController {

    // Outlets for the text fields
    @IBOutlet weak var tUserName: UITextField!
    @IBOutlet weak var tEmail: UITextField!
    @IBOutlet weak var tPassword: UITextField!
    @IBOutlet weak var tConfirmPassword: UITextField!
    @IBOutlet weak var crNumberTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addUserButton: UIButton!

    var newUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the default segment to "Seller" (index 0)
        segmentedControl.selectedSegmentIndex = 0  // Ensure "Seller" is selected by default
        updateCRNumberVisibility() // Update CR Number visibility based on the selected segment
    }

    // MARK: - Action when Add User button is tapped
    @IBAction func addUserButtonTapped(_ sender: UIButton) {
        // Check if the form is valid
        if isFormValid() {
            // Form is valid, create the new user
            newUser = User(
                userName: tUserName.text!,
                email: tEmail.text!,
                password: tPassword.text!,
                crNumber: crNumberTextField.text,  // This can be nil if the user is a "Buyer"
                userType: segmentedControl.selectedSegmentIndex == 0 ? "Seller" : "Buyer"  // "Seller" if first segment, otherwise "Buyer"
            )

            // Show success alert
            let alert = UIAlertController(title: "User Added", message: "The user has been added successfully.", preferredStyle: .alert)

            // Add the "OK" action to the alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                // Perform segue after alert dismisses to go back to the User List screen
                //self?.segueToUserList()
            }))

            // Present the alert
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // Show validation alerts if form is invalid
            let alert = UIAlertController(title: "Incomplete Form", message: "Please fill in all the fields, ensure the passwords match, and provide a valid email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func segueToUserList() {
        // Perform the unwind segue after the alert has been dismissed
        performSegue(withIdentifier: "unwindToUserList", sender: self)
    }

    // MARK: - Validation functions
    func isFormValid() -> Bool {
        // Check if any required fields are empty
        if tUserName.text?.isEmpty == true ||
            tEmail.text?.isEmpty == true ||
            tPassword.text?.isEmpty == true ||
            tConfirmPassword.text?.isEmpty == true ||
            (segmentedControl.selectedSegmentIndex == 0 && crNumberTextField.text?.isEmpty == true) {
            return false
        }

        // Check if email is valid
        if !isEmailValid(email: tEmail.text!) {
            showInvalidEmailAlert()
            return false
        }

        // Check if password and confirm password match
        if tPassword.text != tConfirmPassword.text {
            showPasswordMismatchAlert()
            return false
        }

        // Check if password meets the required format
//        if !isPasswordValid(password: tPassword.text!) {
//            showPasswordFormatAlert()
//            return false
//        }

        return true
    }

    // MARK: - Email validation
    func isEmailValid(email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // MARK: - Password validation
//    func isPasswordValid(password: String) -> Bool {
//        // Check if password meets length (8-12 characters), contains at least one lowercase, one uppercase, one number, and one special character
//        let lowercaseLetterRegEx = ".*[a-z]+.*"
//        let uppercaseLetterRegEx = ".*[A-Z]+.*"
//        let digitRegEx = ".*\\d+.*"
//        let specialCharacterRegEx = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
//
//        // Check each requirement
//        return password.count >= 8 && password.count <= 12 &&
//               password.range(of: lowercaseLetterRegEx, options: .regularExpression) != nil &&
//               password.range(of: uppercaseLetterRegEx, options: .regularExpression) != nil &&
//               password.range(of: digitRegEx, options: .regularExpression) != nil &&
//               password.range(of: specialCharacterRegEx, options: .regularExpression) != nil
//    }

    // MARK: - Show alerts for invalid input
    func showInvalidEmailAlert() {
        let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showPasswordMismatchAlert() {
        let alert = UIAlertController(title: "Password Mismatch", message: "The passwords do not match. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showPasswordFormatAlert() {
        let alert = UIAlertController(title: "Invalid Password", message: "Password must be between 8-12 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Update CR Number visibility
    func updateCRNumberVisibility() {
        // Get the index path for the row containing the CR Number text field (7th row, index 6)
        let indexPath = IndexPath(row: 6, section: 0)

        // Check the selected segment
        if segmentedControl.selectedSegmentIndex == 0 {
            // "Seller" is selected - show the CR Number cell (row 6)
            setCellVisibility(at: indexPath, isHidden: false)
        } else {
            // "Buyer" is selected - hide the CR Number cell (row 6)
            setCellVisibility(at: indexPath, isHidden: true)
        }

        // Update layout to reflect the changes
        self.view.layoutIfNeeded()
    }

    // MARK: - Show or hide the CR Number cell
    func setCellVisibility(at indexPath: IndexPath, isHidden: Bool) {
        // Get the cell for this index path
        if let cell = tableView.cellForRow(at: indexPath) {
            // Hide or show the entire cell
            cell.isHidden = isHidden
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // Ensure that the CR Number text field visibility is updated when the 7th cell (index 6) is reused
        if indexPath.row == 6 {
            updateCRNumberVisibility()
        }

        return cell
    }

    // MARK: - Action when segmented control changes
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        // Update the visibility of the CR Number row whenever the segment is changed
        updateCRNumberVisibility()
    }
}

