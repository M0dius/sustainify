//
//  PITCellView.swift
//  Sustain
//
//  Created by Morris Richman on 12/26/24.
//

import Foundation
import UIKit

class PITStackedCellView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.applyStyle()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyStyle()
    }
    
    func applyStyle() {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
    }
}
