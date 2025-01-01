//
//  PriceBreakdownCell.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class PriceBreakdownCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var keyLable: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(key: String, value: String) {
        keyLable.text = key
        valueLabel.text = value
    }
    
}
