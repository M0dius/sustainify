//
//  AddReviewViewController.swift
//  Sustainify
//
//  Created by Guest User on 15/12/2024.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    var initialTitle: String?
    var initialContent: String?
    var editingReviewIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var postReviewButton: UIButton!
    
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    
    // Callback to pass data back
    var onReviewAdded: ((String, String, Int) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = initialTitle, let content = initialContent {
            titleTextField.text = title
            reviewTextField.text = content
        }
    }
    
    var selectedRating: Int = 0
    
    func starSelected(rating: Int) {
        selectedRating = rating
    }
    
    var currentRating = 0
    
    @IBAction func starButtonTapped1(_ sender: UIButton) {
        updateRating(rating: 1)
    }
    @IBAction func starButtonTapped2(_ sender: UIButton) {
        updateRating(rating: 2)
    }
    @IBAction func starButtonTapped3(_ sender: UIButton) {
        updateRating(rating: 3)
    }
    @IBAction func starButtonTapped4(_ sender: UIButton) {
        updateRating(rating: 4)
    }
    @IBAction func starButtonTapped5(_ sender: UIButton) {
        updateRating(rating: 5)
    }
    
    func updateRating(rating: Int) {
        currentRating = rating
        let starButtons = [starButton1, starButton2, starButton3, starButton4, starButton5]
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
        
    @IBAction func postReviewButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = reviewTextField.text, !content.isEmpty else {
            showAlert(message: "Please enter both title and review.")
            return
        }
        
        // Call the callback to send data back
        onReviewAdded?(title, content, currentRating)
        
        // Navigate back to the previous screen
        navigationController?.popViewController(animated: true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

