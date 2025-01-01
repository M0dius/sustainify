//
//  CartViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var voucherTextField: UITextField!
    
    // MARK: - Properties
    var productsToCheckout: [Product: Int] = [:] { 
        didSet {
            calculateSubtotal()
        }
    }
    private var currentStore: RetailStore?
    private var subtotal: Double = 0.0
    private var voucherDiscount: Double = 0.0
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cart"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableCell.self)
        fetchStoreInfo()
        calculateSubtotal()
    }
    
    // MARK: - Helper Functions
    private func fetchStoreInfo() {
        guard let firstProduct = productsToCheckout.keys.first else { return }
        
        FirebaseManager.fetchStore(with: firstProduct.storeId) { [weak self] store in
            guard let self = self else { return }
            self.currentStore = store
            debugPrint("currentStore", currentStore)
        }
    }
    
    private func calculateSubtotal() {
        subtotal = productsToCheckout.reduce(0.0) { $0 + ($1.key.price * Double($1.value)) }
    }
    
    // MARK: - IBActions
    @IBAction func checkoutButtonAction(_ sender: UIButton) {
        guard let store = currentStore else {
            print("Store information not available")
            return
        }

        if let voucherCode = voucherTextField.text, !voucherCode.isEmpty {
            validateVoucher(for: store) { validationResult in
                DispatchQueue.main.async {
                    switch validationResult {
                    case .valid:
                        print("Voucher is valid")
                        self.navigateToCheckout(with: store)
                        
                    case .invalid(let message):
                        self.showAlert(
                            ofType: .titleOnly(title: message),
                            actions: [(.ok, nil)]
                        )
                        
                    case .none:
                        print("Unexpected validation result")
                    }
                }
            }
        } else {
            navigateToCheckout(with: store)
        }
    }
    
    private func navigateToCheckout(with store: RetailStore) {
        let intent = CheckOutNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push) { (checkoutVC: CheckOutViewController) in
            checkoutVC.voucherDiscount = self.voucherDiscount
            checkoutVC.currentStore = store
            checkoutVC.subtotal = self.subtotal
        }
    }

    @IBAction func voucherChanged(_ sender: UITextField) {
        // Voucher text change handling
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsToCheckout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableCell = tableView.dequeueReusableCell(for: indexPath)
        let product = Array(productsToCheckout.keys)[indexPath.row]
        let count = productsToCheckout[product] ?? 0
        
        // Configure the cell
        cell.itemLabel.text = product.name
        cell.countLabel.text = "\(count)"
        cell.stepper.value = Double(count)
        
        // Handle the Book button closure
        cell.onBookButtonTapped = {
            self.handleBookButton(for: product)
        }
        
        // Handle the Stepper closure
        cell.onStepperValueChanged = { newValue in
            self.updateProductCount(product: product, newCount: newValue)
        }
        return cell
    }
}

extension CartViewController {
    func handleBookButton(for product: Product) {
        FirebaseManager.bookProduct(product) { error in
            if let error = error {
                print("Error booking product: \(error.localizedDescription)")
                self.showAlert(
                    ofType: .titleOnly(title: "Booking Failed"),
                    actions: [(.ok, nil)]
                )
            } else {
                print("Product booked successfully.")
                self.showAlert(
                    ofType: .titleOnly(title: "Item Booked!"),
                    actions: [(.ok, nil)]
                )
            }
        }
    }

    // MARK: - Update Product Count
    func updateProductCount(product: Product, newCount: Int) {
        guard newCount >= 0 else { return }
        if newCount == 0 {
            productsToCheckout.removeValue(forKey: product)
        } else {
            productsToCheckout[product] = newCount
        }
        calculateSubtotal()
        if let index = Array(productsToCheckout.keys).firstIndex(of: product) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
        
    private func validateVoucher(for store: RetailStore, completion: @escaping (VoucherValidationResult?) -> Void) {
        guard let voucherCode = voucherTextField.text?.lowercased(), !voucherCode.isEmpty else {
            completion(nil)
            return
        }
        
        FirebaseManager.fetchVouchers { vouchers in
            if let validVoucher = vouchers.first(where: { $0.code.lowercased() == voucherCode }) {
                if validVoucher.status == "Active" {
                    if let expiryDate = validVoucher.expiryDate.toDate(), Date().isBeforeOrEqual(to: expiryDate) {
                        self.voucherDiscount = validVoucher.discount
                        print("Voucher is valid, discount: \(self.voucherDiscount)")
                        completion(.valid)
                    } else {
                        print("Voucher has expired")
                        completion(.invalid(message: "Voucher has expired"))
                    }
                } else {
                    print("Voucher is disabled or inactive")
                    completion(.invalid(message: "Voucher is disabled or inactive"))
                }
            } else {
                print("Invalid voucher")
                completion(.invalid(message: "Invalid voucher"))
            }
        }
    }
}

private enum VoucherValidationResult {
    case valid
    case invalid(message: String)
}
