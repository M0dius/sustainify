//
//  ReviewTableViewCell.swift
//  Sustainify
//
//  Created by Guest User on 18/12/2024.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        onEdit?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        onDelete?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with review: Review) {
        titleLabel.text = review.title
        reviewLabel.text = review.content
        updateStars(rating: review.rating)
    }

    func updateStars(rating: Int) {
        let starButtons = [starButton1, starButton2, starButton3, starButton4, starButton5]
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
}

