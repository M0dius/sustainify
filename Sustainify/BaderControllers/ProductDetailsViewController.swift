//
//  ProductDetailsViewController.swift
//  Sustainify
//
//  Created by Guest User on 11/12/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var expandedStates: [Bool] = [] // Keeps track of expanded/collapsed states
    var tags: [Tag] = [] // This will hold the tags for the product
    var selectedQuantity: Int = 0 // Variable to store the quantity

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize quantity
        quantityLabel.text = "0"

        // Define tags
        let ecoTag = Tag(name: "Eco Score", description: "This product has an eco score based on sustainability.")
        let tag1 = Tag(name: "Organic", description: "This product is made from organic ingredients.")
        let tag2 = Tag(name: "Fair Trade", description: "This product is certified fair trade.")
        
        // Add tags to the product
        tags = [ecoTag, tag1, tag2]  // Add more or fewer tags as needed

        // Initialize the expandedStates array based on the number of tags
        expandedStates = Array(repeating: false, count: tags.count)

        // Set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Register the custom cell
        //tableView.register(UINib(nibName: "TagsTableViewCell", bundle: nil), forCellReuseIdentifier: "TagsTableViewCell")

        // Enable dynamic row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    @IBAction func quantityStepper(_ sender: UIStepper) {
            // Update label with value
            quantityLabel.text = Int(sender.value).description
        }

        @IBAction func addToCartButtonClicked(_ sender: UIButton) {
            if let quantity = Int(quantityLabel.text ?? "0") {
                selectedQuantity = quantity
                print("Quantity added to cart: \(selectedQuantity)")
            }
        }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath) as? TagsTableViewCell else {
            fatalError("Failed to dequeue TagsTableViewCell")
        }

        // Get the current tag
        let tag = tags[indexPath.row]

        // Configure the cell
        cell.tagLabel.text = tag.name
        cell.infoLabel.text = tag.description

        // Set the visibility of the infoLabel based on the expanded state
        cell.infoLabel.isHidden = !expandedStates[indexPath.row]

        return cell
    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the expanded state of the selected cell
        expandedStates[indexPath.row].toggle()

        // Reload the affected row to apply the changes
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
