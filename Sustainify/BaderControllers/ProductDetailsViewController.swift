//
//  ProductDetailsViewController.swift
//  Sustainify
//
//  Created by Guest User on 11/12/2024.
//

import UIKit
import Firebase

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!

    var storeID: String?
    var productID: String?
    var productDetails: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Details"
        fetchProductDetails()
    }

    func fetchProductDetails() {
        guard let storeID = storeID, let productID = productID else { return }
        let db = Firestore.firestore()
        
        db.collection("Stores").document(storeID).collection("Products").document(productID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching product details: \(error)")
            } else if let data = snapshot?.data() {
                self.productDetails = data
                self.descriptionLabel.text = data["description"] as? String ?? "No Description Available"
            }
        }
    }

    @IBAction func quantityStepperChanged(_ sender: UIStepper) {
        quantityLabel.text = Int(sender.value).description
    }

    @IBAction func addToCartButtonTapped(_ sender: UIButton) {
        print("Quantity added to cart: \(quantityLabel.text ?? "0")")
    }
}
