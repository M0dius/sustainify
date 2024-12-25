//
//  ProductDetailsViewController.swift
//  Sustainify
//
//  Created by Guest User on 11/12/2024.
//

import UIKit

class ProductDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate /*UICollectionViewDataSource, UICollectionViewDelegateFlowLayout*/ {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    

    var expandedStates: [Bool] = []
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

        // Register a custom cell class if necessary
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")

        // Allow table view to calculate row height automatically
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        // Set the description label text
        //let product = Product(name: "Sample Product", discription: "this product has been proven to be effective in eliminating curses of grade 1 and even special grade", tags: tags); descriptionLabel.text = product.discription
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        let tag = tags[indexPath.row]
        cell.textLabel?.text = tag.name
        cell.textLabel?.numberOfLines = 0  // Enable multiline

        if expandedStates[indexPath.row] {
            cell.detailTextLabel?.text = tag.description
            cell.detailTextLabel?.numberOfLines = 0  // Enable multiline
        } else {
            cell.detailTextLabel?.text = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the expanded state of the selected cell
        expandedStates[indexPath.row].toggle()

        // Reload the affected row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
