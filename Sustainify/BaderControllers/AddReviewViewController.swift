//
//  AddReviewViewController.swift
//  Sustainify
//
//  Created by Guest User on 15/12/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class AddReviewViewController: UIViewController {
    
    var ref: DocumentReference?
    var initialTitle: String?
    var initialContent: String?
    var editingReviewIndex: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var postReviewButton: UIButton!
    
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    
    var onReviewAdded: (() -> Void)?
    var selectedRating: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial values if editing
        if let title = initialTitle, let content = initialContent {
            titleTextField.text = title
            reviewTextField.text = content
            updateRating(rating: selectedRating)
        }
    }

    @IBAction func postReviewButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = reviewTextField.text, !content.isEmpty else {
            showAlert(message: "Please enter both title and review.")
            return
        }
        
        saveReviewToFirebase(title: title, content: content, rating: selectedRating)
        
        // Call the callback to refresh the table view in ReviewsTableViewController
        onReviewAdded?()
        navigationController?.popViewController(animated: true)
    }
    
    func saveReviewToFirebase(title: String, content: String, rating: Int) {
        guard let user = Auth.auth().currentUser else {
            showAlert(message: "User not logged in. Please log in to submit a review.")
            return
        }
        
        let uniqueID = UUID().uuidString // Generate a unique identifier for the review
        let userID = user.uid // Get the currently logged-in user's ID
        
        let db = Firestore.firestore()
        
        // Add new review
        db.collection("Reviews").addDocument(data: [
            "id": uniqueID, // Unique review ID
            "userID": userID, // User ID of the logged-in user
            "title": title,
            "content": content,
            "rating": rating,
            "timestamp": Timestamp() // Add a timestamp for the review
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully added!")
            }
        }
    }

    @IBAction func starButtonTapped1(_ sender: UIButton) { updateRating(rating: 1) }
    @IBAction func starButtonTapped2(_ sender: UIButton) { updateRating(rating: 2) }
    @IBAction func starButtonTapped3(_ sender: UIButton) { updateRating(rating: 3) }
    @IBAction func starButtonTapped4(_ sender: UIButton) { updateRating(rating: 4) }
    @IBAction func starButtonTapped5(_ sender: UIButton) { updateRating(rating: 5) }

    func updateRating(rating: Int) {
        selectedRating = rating
        let starButtons = [starButton1, starButton2, starButton3, starButton4, starButton5]
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

