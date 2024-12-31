//
//  OrderHistoryTableViewCell.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//
import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure labels for multi-line text if needed
        detailsLabel.numberOfLines = 0
    }
    
    // MARK: - Configure Cell
    func configureCell(order: Order) {
        // Set the Order ID label
        orderIDLabel.text = "Order#\(order.id)"
        
        // Set the Order Details label in the required format
        let detailsText = "Items Bought: \(order.itemsCount), Total Price: $\(order.totalPrice), Status: \(order.status)"
        detailsLabel.text = detailsText
    }
}
