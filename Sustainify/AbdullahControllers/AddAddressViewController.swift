//
//  AddressListViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTypeSegmentedControl: UISegmentedControl!
    
    // Address title
    @IBOutlet weak var addressTitleField: UITextField!
    
    // House Fields
    @IBOutlet weak var houseField: UITextField!
    @IBOutlet weak var blockField: UITextField!
    @IBOutlet weak var roadField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    // Apartment Fields
    @IBOutlet weak var apartmentNumberField: UITextField!
    @IBOutlet weak var buildingField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    
    // Office Fields
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var officeNumberField: UITextField!
    
    // Save Button
    @IBOutlet weak var saveButton: UIButton!
    
    var db = Firestore.firestore()
    var selectedAddressType = "House"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI based on the selected address type
        updateUIForAddressType(selectedAddressType)

        // Set the keyboard type for number fields
        setNumberFieldsKeyboard()

        // Add target to the segmented control to detect address type change
        addressTypeSegmentedControl.addTarget(self, action: #selector(addressTypeChanged), for: .valueChanged)
    }

    @objc func addressTypeChanged() {
        switch addressTypeSegmentedControl.selectedSegmentIndex {
        case 0: selectedAddressType = "House"
        case 1: selectedAddressType = "Apartment"
        case 2: selectedAddressType = "Office"
        default: selectedAddressType = "House"
        }
        updateUIForAddressType(selectedAddressType)
    }

    func updateUIForAddressType(_ type: String) {
        switch type {
        case "House":
            houseField.isHidden = false
            blockField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false
            apartmentNumberField.isHidden = true
            buildingField.isHidden = true
            floorField.isHidden = true
            companyField.isHidden = true
            officeNumberField.isHidden = true
        case "Apartment":
            apartmentNumberField.isHidden = false
            buildingField.isHidden = false
            floorField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false
            houseField.isHidden = true
            blockField.isHidden = true
            companyField.isHidden = true
            officeNumberField.isHidden = true
        case "Office":
            companyField.isHidden = false
            buildingField.isHidden = false
            floorField.isHidden = false
            officeNumberField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false
            houseField.isHidden = true
            blockField.isHidden = true
            apartmentNumberField.isHidden = true
        default:
            break
        }
    }

    // Set the keyboard type for fields that should only accept numbers
    func setNumberFieldsKeyboard() {
        houseField.keyboardType = .numberPad
        blockField.keyboardType = .numberPad
        roadField.keyboardType = .numberPad
        phoneNumberField.keyboardType = .phonePad
        apartmentNumberField.keyboardType = .numberPad
        buildingField.keyboardType = .numberPad
        floorField.keyboardType = .numberPad
        officeNumberField.keyboardType = .numberPad
    }

    // Validate number fields to ensure only digits are entered
    func isValidNumber(_ text: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: "0123456789")
        return text.rangeOfCharacter(from: characterSet.inverted) == nil
    }

    @IBAction func saveAddressButtonTapped(_ sender: UIButton) {
        // Get the current logged-in user's UID
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            return
        }

        // Validate the required fields based on address type
        if !validateFieldsForAddressType() {
            // Show an alert or handle validation error
            let alert = UIAlertController(title: "Error", message: "Please fill all required fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // Prepare address data to be saved
        var addressData: [String: Any] = [:]

        // Add address details to the dictionary
        addressData["addressType"] = selectedAddressType
        addressData["address"] = addressTitleField.text ?? ""
        addressData["house"] = houseField.text ?? ""
        addressData["block"] = blockField.text ?? ""
        addressData["road"] = roadField.text ?? ""
        addressData["phoneNumber"] = phoneNumberField.text ?? ""
        addressData["apartmentNumber"] = apartmentNumberField.text ?? ""
        addressData["building"] = buildingField.text ?? ""
        addressData["floor"] = floorField.text ?? ""
        addressData["company"] = companyField.text ?? ""
        addressData["officeNumber"] = officeNumberField.text ?? ""
        
        // Add the user ID to the address data
        addressData["userID"] = userID

        // Save the address to Firestore
        db.collection("Addresses").addDocument(data: addressData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                // Successfully saved address, go back to the previous screen
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // Validate the required fields for each address type
    func validateFieldsForAddressType() -> Bool {
        switch selectedAddressType {
        case "House":
            // Ensure all house fields are filled
            return !(houseField.text?.isEmpty ?? true) &&
                   !(blockField.text?.isEmpty ?? true) &&
                   !(roadField.text?.isEmpty ?? true) &&
                   !(phoneNumberField.text?.isEmpty ?? true)
        case "Apartment":
            // Ensure all apartment fields are filled
            return !(apartmentNumberField.text?.isEmpty ?? true) &&
                   !(buildingField.text?.isEmpty ?? true) &&
                   !(floorField.text?.isEmpty ?? true) &&
                   !(roadField.text?.isEmpty ?? true) &&
                   !(phoneNumberField.text?.isEmpty ?? true)
        case "Office":
            // Ensure all office fields are filled
            return !(companyField.text?.isEmpty ?? true) &&
                   !(buildingField.text?.isEmpty ?? true) &&
                   !(floorField.text?.isEmpty ?? true) &&
                   !(officeNumberField.text?.isEmpty ?? true) &&
                   !(roadField.text?.isEmpty ?? true) &&
                   !(phoneNumberField.text?.isEmpty ?? true)
        default:
            return false
        }
    }
}
