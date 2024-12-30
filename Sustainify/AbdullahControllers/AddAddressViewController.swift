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

        updateUIForAddressType(selectedAddressType)

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

    @IBAction func saveAddressButtonTapped(_ sender: UIButton) {
        // Get the current logged-in user's UID
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
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
}
