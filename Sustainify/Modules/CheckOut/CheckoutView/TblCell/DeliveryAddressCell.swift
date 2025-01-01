//
//  DeliveryAddressCell.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class DeliveryAddressCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var addressLable: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    
    var changeButtonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBactions
    @IBAction func changeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
