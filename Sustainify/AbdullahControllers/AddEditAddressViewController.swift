//
//  AddEditAddressViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit
import FirebaseFirestore

class AddEditAddressViewController: UIViewController {
    
    
    @IBOutlet weak var addressTypeSegmentedControl: UISegmentedControl!
    
    //Address title
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
    
    // The currently selected address type
    var selectedAddressType = "House"
    
    // Flag to determine if we're editing an address or adding a new one
    var isEditingAddress = false
    
    // Address data when editing
    var addressToEdit: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the UI for adding or editing an address
        setupUIForMode()
        
        // Initially show fields for House address type
        updateUIForAddressType(selectedAddressType)
        
        // Handle segmented control change
        addressTypeSegmentedControl.addTarget(self, action: #selector(addressTypeChanged), for: .valueChanged)
        
        // If editing, populate fields with existing data
        if isEditingAddress, let address = addressToEdit {
            populateFieldsWithAddressData(address)
        }
    }
    
    func setupUIForMode() {
        if isEditingAddress {
            // Change title and button text for editing
            navigationItem.title = "Edit Address"
            saveButton.setTitle("Save Changes", for: .normal)
            
            // Disable the segmented control when editing
            addressTypeSegmentedControl.isEnabled = false
        } else {
            // Change title and button text for adding
            navigationItem.title = "Add Address"
            saveButton.setTitle("Add Address", for: .normal)
        }
    }
    
    @objc func addressTypeChanged() {
        switch addressTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            selectedAddressType = "House"
        case 1:
            selectedAddressType = "Apartment"
        case 2:
            selectedAddressType = "Office"
        default:
            selectedAddressType = "House"
        }
        updateUIForAddressType(selectedAddressType)
    }

    func updateUIForAddressType(_ type: String) {
        switch type {
        case "House":
            // Show house fields
            houseField.isHidden = false
            blockField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false
            
            // Hide apartment and office fields
            apartmentNumberField.isHidden = true
            buildingField.isHidden = true
            floorField.isHidden = true
            companyField.isHidden = true
            officeNumberField.isHidden = true
            
        case "Apartment":
            // Show apartment fields
            apartmentNumberField.isHidden = false
            buildingField.isHidden = false
            floorField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false

            // Hide house and office fields
            houseField.isHidden = true
            blockField.isHidden = true
            companyField.isHidden = true
            officeNumberField.isHidden = true
            
        case "Office":
            // Show office fields
            companyField.isHidden = false
            buildingField.isHidden = false
            floorField.isHidden = false
            officeNumberField.isHidden = false
            roadField.isHidden = false
            phoneNumberField.isHidden = false

            // Hide house and apartment fields
            houseField.isHidden = true
            blockField.isHidden = true
            apartmentNumberField.isHidden = true
        default:
            break
        }
    }

    func populateFieldsWithAddressData(_ address: [String: Any]) {
        // Populate the fields with data if editing
        if let addressType = address["addressType"] as? String {
            switch addressType {
            case "House":
                houseField.text = address["house"] as? String
                blockField.text = address["block"] as? String
                roadField.text = address["road"] as? String
                phoneNumberField.text = address["phoneNumber"] as? String
                addressTypeSegmentedControl.selectedSegmentIndex = 0
                
            case "Apartment":
                apartmentNumberField.text = address["apartmentNumber"] as? String
                buildingField.text = address["building"] as? String
                floorField.text = address["floor"] as? String
                blockField.text = address["block"] as? String
                roadField.text = address["road"] as? String
                phoneNumberField.text = address["phoneNumber"] as? String
                addressTypeSegmentedControl.selectedSegmentIndex = 1
                
            case "Office":
                companyField.text = address["company"] as? String
                buildingField.text = address["building"] as? String
                floorField.text = address["floor"] as? String
                officeNumberField.text = address["officeNumber"] as? String
                blockField.text = address["block"] as? String
                roadField.text = address["road"] as? String
                phoneNumberField.text = address["phoneNumber"] as? String
                addressTypeSegmentedControl.selectedSegmentIndex = 2
                
            default:
                break
            }
        }
    }
    
    @IBAction func saveAddressButtonTapped(_ sender: UIButton) {
        // Get the data from fields based on address type
        var addressData: [String: Any] = [:]
        
        switch selectedAddressType {
        case "House":
            addressData["addressType"] = "House"
            addressData["house"] = houseField.text ?? ""
            addressData["block"] = blockField.text ?? ""
            addressData["road"] = roadField.text ?? ""
            addressData["phoneNumber"] = phoneNumberField.text ?? ""
            
        case "Apartment":
            addressData["addressType"] = "Apartment"
            addressData["apartmentNumber"] = apartmentNumberField.text ?? ""
            addressData["building"] = buildingField.text ?? ""
            addressData["floor"] = floorField.text ?? ""
            addressData["block"] = blockField.text ?? ""
            addressData["road"] = roadField.text ?? ""
            addressData["phoneNumber"] = phoneNumberField.text ?? ""
            
        case "Office":
            addressData["addressType"] = "Office"
            addressData["company"] = companyField.text ?? ""
            addressData["building"] = buildingField.text ?? ""
            addressData["floor"] = floorField.text ?? ""
            addressData["officeNumber"] = officeNumberField.text ?? ""
            addressData["block"] = blockField.text ?? ""
            addressData["road"] = roadField.text ?? ""
            addressData["phoneNumber"] = phoneNumberField.text ?? ""
        default:
            break
        }

        if isEditingAddress, let addressId = addressToEdit?["id"] as? String {
            // Update the existing address
            db.collection("Addresses").document(addressId).updateData(addressData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Address updated successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            // Add the new address
            db.collection("Addresses").addDocument(data: addressData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Address added successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // Add a back button to navigate back to the previous page
    func addBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
