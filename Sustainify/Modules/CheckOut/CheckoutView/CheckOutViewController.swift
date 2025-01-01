//
//  CheckOutViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class CheckOutViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let sections: [String] = ["Delivery Address", "Payment Method", "Price Breakdown"]
    var deliveryAddress: String = "Home House 1754, Road 584, Block 456, Janabiya, Manama"
    var selectedPaymentMethod: PaymentMethod? = nil
    var subtotal: Double = 0.0
    var currentStore: RetailStore?
    var voucherDiscount: Double = 0.0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Checkout"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryAddressCell.self)
        tableView.register(PaymentMethodCell.self)
        tableView.register(PriceBreakdownCell.self)
    }

    // MARK: - Actions
    @objc private func changeAddressTapped() {
        print("Change Address Tapped")
    }

    // MARK: - Helper Functions
    private func getPriceBreakdown() -> [(String, String)] {
        let deliveryFee = currentStore?.deliveryFee ?? 0.0
        let discountedSubtotal = max(0, subtotal - voucherDiscount)
        let totalAmount = discountedSubtotal + deliveryFee

        var breakdown: [(String, String)] = [
            ("Subtotal", subtotal.formattedAsCurrency())
        ]

        if voucherDiscount > 0 {
            breakdown.append(("Voucher Discount", "-\(voucherDiscount.formattedAsCurrency())"))
        }

        breakdown.append(("Delivery Fee", deliveryFee.formattedAsCurrency()))
        breakdown.append(("Total Amount", totalAmount.formattedAsCurrency()))

        return breakdown
    }
    
    private func getRowsInSections() -> [[Any]] {
        let paymentMethods = PaymentMethod.allCases
        let priceBreakdown = getPriceBreakdown()
        return [[deliveryAddress], paymentMethods, priceBreakdown]
    }
    
    @IBAction func confirmOrder(sender: UIButton) {
        let intent = DeliveryNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push)
    }
}

// MARK: - UITableViewDataSource
extension CheckOutViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowsInSections()[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textColor = .black
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowsInSections = getRowsInSections()
        switch indexPath.section {
        case 0:
            let cell: DeliveryAddressCell = tableView.dequeueReusableCell(for: indexPath)
            cell.changeButtonAction = { [weak self] in
                self?.changeAddressTapped()
            }
            return cell
        case 1:
            let cell: PaymentMethodCell = tableView.dequeueReusableCell(for: indexPath)
            if let paymentMethod = rowsInSections[indexPath.section][indexPath.row] as? PaymentMethod {
                cell.configure(
                    with: paymentMethod.getDescription(),
                    isSelected: selectedPaymentMethod == paymentMethod
                )
            }
            return cell
        case 2:
            let cell: PriceBreakdownCell = tableView.dequeueReusableCell(for: indexPath)
            if let detail = rowsInSections[indexPath.section][indexPath.row] as? (String, String) {
                cell.configure(key: detail.0, value: detail.1)
            }
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}

// MARK: - UITableViewDelegate
extension CheckOutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let rowsInSections = getRowsInSections()
            if let paymentMethod = rowsInSections[indexPath.section][indexPath.row] as? PaymentMethod {
                selectedPaymentMethod = paymentMethod
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
}
