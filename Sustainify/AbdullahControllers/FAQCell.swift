//
//  FAQCell.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit

class FAQCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set default properties for labels
        questionLabel.numberOfLines = 0  // Allow the question to wrap across multiple lines
        answerLabel.numberOfLines = 0    // Allow the answer to expand to multiple lines
        answerLabel.lineBreakMode = .byWordWrapping  // Ensure the text wraps properly
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure layout updates after expanding or collapsing the answer
        self.contentView.layoutIfNeeded()

        // Set the max width for the labels to avoid overflowing
        let maxWidth = UIScreen.main.bounds.width - 30 // Account for padding/margins (30px is just an estimate)
        questionLabel.preferredMaxLayoutWidth = maxWidth
        answerLabel.preferredMaxLayoutWidth = maxWidth
        
        // Fix the layout issue in case the cell was collapsed and then expanded
        questionLabel.sizeToFit() // Make sure the question label adjusts its size
        answerLabel.sizeToFit()   // Make sure the answer label adjusts its size
    }
}
