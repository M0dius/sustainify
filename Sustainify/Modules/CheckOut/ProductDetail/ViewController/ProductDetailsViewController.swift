//
//  ProductDetailsViewController.swift
//  Sustainify
//
//  Created by Guest User on 11/12/2024.
//

import UIKit
import Foundation

class ProductDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    // MARK: - Properties
    var expandedStates: [Bool] = []
    var tags: [Tag] = []
    var productsToCheckout: [Product: Int] = [:]
    var selectedProduct: Product? 
    var onCompletion: (([Product: Int]) -> Void)?

    private var quantity: Int {
        guard let product = selectedProduct else { return 0 }
        return productsToCheckout[product] ?? 0
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup Methods
    private func setupView() {
        self.navigationItem.title = "Bottles Set"
        tags = Tag.mockTags
        expandedStates = Array(repeating: false, count: tags.count)
        setupTableView()
        updateQuantityLabel()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    // MARK: - IBActions
    @IBAction func addToCartButtonClicked(_ sender: UIButton) {
        print("Products added to cart: \(productsToCheckout)")
        onCompletion?(productsToCheckout)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func plusAction(sender: UIButton) {
        guard let product = selectedProduct else { return }
        updateProductCount(for: product, increment: true)
    }

    @IBAction func minusAction(sender: UIButton) {
        guard let product = selectedProduct else { return }
        updateProductCount(for: product, increment: false)
    }
}

// MARK: - UITableViewDataSource
extension ProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TagsTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        let tag = tags[indexPath.row]
        cell.tagLabel.text = tag.name
        cell.infoLabel.text = tag.description
        cell.infoLabel.isHidden = !expandedStates[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandedStates[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Helper Methods
extension ProductDetailsViewController {
    /// Updates the count of the specified product
    /// - Parameters:
    ///   - product: The product to update
    ///   - increment: Boolean to indicate whether to increment or decrement
    private func updateProductCount(for product: Product, increment: Bool) {
        if increment {
            if let currentCount = productsToCheckout[product] {
                productsToCheckout[product] = currentCount + 1
                FirebaseManager.updateCartProductCount(product, count: currentCount + 1) { error in
                    if let error = error {
                        print("Error updating product count in cart: \(error.localizedDescription)")
                    } else {
                        print("Product count updated in cart successfully!")
                    }
                }
            } else {
                productsToCheckout[product] = 1
                FirebaseManager.saveProductsToCart([product: 1]) { error in
                    if let error = error {
                        print("Error saving product to cart: \(error.localizedDescription)")
                    } else {
                        print("Product saved to cart successfully!")
                    }
                }
            }
        } else {
            if let currentCount = productsToCheckout[product], currentCount > 0 {
                productsToCheckout[product] = currentCount - 1
                if productsToCheckout[product] == 0 {
                    productsToCheckout.removeValue(forKey: product)
                    FirebaseManager.updateCartProductCount(product, count: 0) { error in
                        if let error = error {
                            print("Error removing product from cart: \(error.localizedDescription)")
                        } else {
                            print("Product removed from cart successfully!")
                        }
                    }
                }
            } else {
                if productsToCheckout[product] == 0 {
                    productsToCheckout.removeValue(forKey: product)
                    FirebaseManager.updateCartProductCount(product, count: 0) { error in
                        if let error = error {
                            print("Error removing product from cart: \(error.localizedDescription)")
                        } else {
                            print("Product removed from cart successfully!")
                        }
                    }
                }
            }
        }
        print("Updated product counts: \(productsToCheckout)")
        updateQuantityLabel()
    }

    /// Updates the quantity label and enables/disables the minus button
    private func updateQuantityLabel() {
        quantityLabel.text = "\(quantity)"
        minusButton.isEnabled = quantity > 0
    }
}
