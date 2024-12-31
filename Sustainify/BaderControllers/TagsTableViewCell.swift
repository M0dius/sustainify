//
//  TagsTableViewCell.swift
//  Sustainify
//
//  Created by Guest User on 28/12/2024.
//

import UIKit

class TagsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Allow multiline for labels
        tagLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure proper layout after expansion/collapse
        contentView.layoutIfNeeded()

        // Set preferred max width for labels to avoid overflow
        let maxWidth = UIScreen.main.bounds.width - 30 // Adjust based on padding
        tagLabel.preferredMaxLayoutWidth = maxWidth
        infoLabel.preferredMaxLayoutWidth = maxWidth
    }
}
