//
//  EditAddressViewController.swift
//  Sustainify
//
//  Created by Guest User on 29/12/2024.
//

import UIKit
import FirebaseFirestore

class EditAddressViewController: UIViewController {

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
    var addressID: String!
    var selectedAddressType = "House"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update UI based on the selected address type
        updateUIForAddressType(selectedAddressType)

        // Add target to the segmented control to detect address type change
        addressTypeSegmentedControl.addTarget(self, action: #selector(addressTypeChanged), for: .valueChanged)

        // Fetch address data if editing an existing address
        if let addressID = addressID {
            fetchAddressData(addressID)
        }
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
            addressTypeSegmentedControl.selectedSegmentIndex = 0
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
            addressTypeSegmentedControl.selectedSegmentIndex = 1
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
            addressTypeSegmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }

    // Fetch address data from Firestore
    func fetchAddressData(_ addressID: String) {
        db.collection("Addresses").document(addressID).getDocument { document, error in
            if let error = error {
                print("Error fetching address: \(error)")
            } else if let document = document, document.exists {
                let data = document.data()
                
                // Fill in the fields with existing data
                self.addressTitleField.text = data?["address"] as? String
                self.houseField.text = data?["house"] as? String
                self.blockField.text = data?["block"] as? String
                self.roadField.text = data?["road"] as? String
                self.phoneNumberField.text = data?["phoneNumber"] as? String
                self.apartmentNumberField.text = data?["apartmentNumber"] as? String
                self.buildingField.text = data?["building"] as? String
                self.floorField.text = data?["floor"] as? String
                self.companyField.text = data?["company"] as? String
                self.officeNumberField.text = data?["officeNumber"] as? String
                self.selectedAddressType = data?["addressType"] as? String ?? "House"
                
                // Update UI with the correct address type
                self.updateUIForAddressType(self.selectedAddressType)
            }
        }
    }

    // Save address data to Firestore
    @IBAction func saveAddress(_ sender: Any) {
        guard let addressID = addressID else { return }

        // Validate the fields based on address type
        if !validateFieldsForAddressType() {
            let alert = UIAlertController(title: "Error", message: "Please fill all required fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let updatedData: [String: Any] = [
            "address": addressTitleField.text ?? "",
            "addressType": selectedAddressType,
            "house": houseField.text ?? "",
            "block": blockField.text ?? "",
            "road": roadField.text ?? "",
            "phoneNumber": phoneNumberField.text ?? "",
            "apartmentNumber": apartmentNumberField.text ?? "",
            "building": buildingField.text ?? "",
            "floor": floorField.text ?? "",
            "company": companyField.text ?? "",
            "officeNumber": officeNumberField.text ?? ""
        ]
        
        db.collection("Addresses").document(addressID).updateData(updatedData) { error in
            if let error = error {
                print("Error updating address: \(error)")
            } else {
                // Go back to the address list
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // Validate the required fields for each address type
    func validateFieldsForAddressType() -> Bool {
        switch selectedAddressType {
        case "House":
            return !(houseField.text?.isEmpty ?? true) &&
                   !(blockField.text?.isEmpty ?? true) &&
                   !(roadField.text?.isEmpty ?? true) &&
                   !(phoneNumberField.text?.isEmpty ?? true)
        case "Apartment":
            return !(apartmentNumberField.text?.isEmpty ?? true) &&
                   !(buildingField.text?.isEmpty ?? true) &&
                   !(floorField.text?.isEmpty ?? true) &&
                   !(roadField.text?.isEmpty ?? true) &&
                   !(phoneNumberField.text?.isEmpty ?? true)
        case "Office":
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
