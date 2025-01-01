//
//  ProductViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewCartBtn: UIButton!

    // MARK: - Properties
    var products: [Product] = []
    let storeId = "50E709EC-C7C3-453B-B576-967FB1A1CCEF"
    var productsToCheckout: [Product: Int] = [:] {
        didSet {
            updateCartInfo()
        }
    }

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        FirebaseManager.saveMockData()
        setupTableView()
        fetchProducts()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self)
    }

    private func fetchProducts() {
        FirebaseManager.fetchProducts(for: storeId) { [weak self] products in
            self?.products = products
            self?.tableView.reloadData()
        }
    }

    private func updateCartInfo() {
        // Calculate total item count
        let itemCount = productsToCheckout.values.reduce(0, +)
        itemCountLbl.text = "\(itemCount)"

        let totalPrice = productsToCheckout.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
        viewCartBtn.setTitle("View Cart \(String(format: "%.3f", totalPrice)) BD", for: .normal)
    }

    // MARK: - IBActions
    @IBAction func viewCartButtonTapped(_ sender: UIButton) {
        let intent = CartNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push) { (vc: CartViewController) in
            vc.productsToCheckout = self.productsToCheckout
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCell = tableView.dequeueReusableCell(for: indexPath)
        let product = products[indexPath.row]
        cell.configureCell(product)
        cell.completion = { [weak self] in
            self?.addProduct(product: product)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let intent = ProductDetailNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push) { (vc: ProductDetailsViewController) in
            vc.selectedProduct = self.products[indexPath.row]
            vc.productsToCheckout = self.productsToCheckout
            vc.onCompletion = { [weak self] updatedProducts in
                self?.productsToCheckout = updatedProducts
            }
        }
    }
}

// MARK: - Product Handling
extension ProductViewController {
    /// Adds or increments a product in the checkout dictionary
    /// - Parameter product: The product to add or increment
    func addProduct(product: Product) {
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
    }
}
