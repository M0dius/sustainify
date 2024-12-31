//
//  AllReviewsTableViewCell.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//

import UIKit

class AllReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var allReviewsTitle: UILabel!
    @IBOutlet weak var allReviewsStars: UILabel!
    @IBOutlet weak var allReviewsContent: UILabel!
    @IBOutlet weak var allReviewsReport: UIButton!
    
    
    var onReport: (() -> Void)?
    
    @IBAction func reportButtonTapped(_ sender: UIButton) {
        onReport?()
    }
}
