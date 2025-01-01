//
//  CartTableCell.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import UIKit

class CartTableCell: UITableViewCell, ReusableView, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var onBookButtonTapped: (() -> Void)?
    var onStepperValueChanged: ((_ value: Int) -> Void)?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func bookButtonTapped(_ sender: UIButton) {
        print("Book button tapped")
        onBookButtonTapped?()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let currentValue = Int(sender.value)
        countLabel.text = "\(currentValue)"
        print("Stepper value changed to \(sender.value)")
        onStepperValueChanged?(currentValue)
    }
}
