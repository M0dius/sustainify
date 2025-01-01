//
//  PaymentMethodCell.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class PaymentMethodCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var keyLable: UILabel!
    @IBOutlet weak var radioButtonImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with paymentMethod: String, isSelected: Bool) {
        keyLable.text = paymentMethod
        radioButtonImageView.image = UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle")
        radioButtonImageView.tintColor = isSelected ? .systemGreen : .lightGray
    }
}
