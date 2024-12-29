//
//  ReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 15/12/2024.
//

import UIKit
import Firebase

class ReviewsTableViewController: UITableViewController {
    
    var reviews: [(id: String, title: String, content: String, rating: Int)] = [] // Add an `id` to track Firestore document IDs.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        // Add the Edit button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))

        fetchReviewsFromFirestore()
    }
    
    func fetchReviewsFromFirestore() {
        let db = Firestore.firestore()
        
        db.collection("Reviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reviews: \(error)")
            } else {
                self.reviews = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let title = data["title"] as? String ?? "No title"
                    let content = data["content"] as? String ?? "No content"
                    let rating = data["rating"] as? Int ?? 0
                    return (id: document.documentID, title: title, content: content, rating: rating) // Add document ID
                } ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func toggleEditingMode() {
        // Toggle the table view editing mode
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func deleteReview(at index: Int) {
        let review = reviews[index]
        let db = Firestore.firestore()
        
        db.collection("Reviews").document(review.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted!")
                self.reviews.remove(at: index) // Update local data
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic) // Update table view
            }
        }
    }

    func confirmDeleteReview(at index: Int) {
        let alert = UIAlertController(title: "Delete Review", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteReview(at: index)
        }))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else {
            fatalError("Unable to dequeue ReviewTableViewCell")
        }
        
        let review = reviews[indexPath.row]
        cell.titleLabel.text = review.title
        cell.reviewLabel.text = review.content
        cell.updateStars(rating: review.rating)
        cell.starsLabel.text = "\(review.rating) stars"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow all rows to be editable
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDeleteReview(at: indexPath.row)
        }
    }
}

