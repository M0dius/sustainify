//
//  ProductCell.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class ProductCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    // MARK: - Properties
    var completion:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        completion?()
    }
    
    func configureCell(_ product: Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = String(format: "%.3f", product.price)
    }
}
