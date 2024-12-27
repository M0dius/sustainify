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

            // Set label's maximum width to prevent overflowing content (based on screen width)
            let maxWidth = UIScreen.main.bounds.width - 30 // Account for padding/margins
            questionLabel.preferredMaxLayoutWidth = maxWidth
            answerLabel.preferredMaxLayoutWidth = maxWidth
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            // Make sure layout is correctly updated when expanding or collapsing the answer
            self.contentView.layoutIfNeeded()
        }
    }
