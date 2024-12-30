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
        
        // Configure labels for multi-line text
        questionLabel.numberOfLines = 0  // Allow the question label to wrap
        questionLabel.lineBreakMode = .byWordWrapping
        
        answerLabel.numberOfLines = 0  // Allow the answer label to expand
        answerLabel.lineBreakMode = .byWordWrapping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Trigger layout updates for content view
        self.contentView.layoutIfNeeded()

        // Calculate and set the max layout width for labels
        let maxWidth = self.contentView.bounds.width - 30 // Adjust for padding (15px left + 15px right)
        questionLabel.preferredMaxLayoutWidth = maxWidth
        answerLabel.preferredMaxLayoutWidth = maxWidth
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset the text and layout properties to avoid reusing stale values
        questionLabel.text = nil
        answerLabel.text = nil
        questionLabel.preferredMaxLayoutWidth = 0
        answerLabel.preferredMaxLayoutWidth = 0
    }
}
