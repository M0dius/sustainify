//
//  ReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 15/12/2024.
//

import UIKit
import Firebase

class ReviewsTableViewController: UITableViewController {
    
    var reviews: [(title: String, content: String, rating: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
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
                    return (title: title, content: content, rating: rating)
                } ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddReview",
           let addReviewVC = segue.destination as? AddReviewViewController {
            
            addReviewVC.onReviewAdded = { [weak self] in
                self?.fetchReviewsFromFirestore()
            }
        }
    }
    
    func navigateToEditReview(at index: Int) {
        let review = reviews[index]
        
        if let addReviewVC = storyboard?.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            // Pass the existing data to the AddReviewViewController
            addReviewVC.initialTitle = review.title
            addReviewVC.initialContent = review.content
            addReviewVC.selectedRating = review.rating
            
            // Pass the document ID to allow editing
            let db = Firestore.firestore()
            db.collection("Reviews").whereField("title", isEqualTo: review.title).getDocuments { snapshot, error in
                if let document = snapshot?.documents.first {
                    addReviewVC.ref = document.reference // Pass the reference for editing
                }
            }
            
            // Callback to reload data after editing
            addReviewVC.onReviewAdded = { [weak self] in
                self?.fetchReviewsFromFirestore()
            }
            
            navigationController?.pushViewController(addReviewVC, animated: true)
        }
    }
    
    func deleteReview(at index: Int) {
        let review = reviews[index]
        let db = Firestore.firestore()
        
        db.collection("Reviews").whereField("title", isEqualTo: review.title).getDocuments { snapshot, error in
            if let document = snapshot?.documents.first {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    } else {
                        print("Document successfully deleted!")
                        self.reviews.remove(at: index) // Update local data
                        self.tableView.reloadData()  // Reload table view
                    }
                }
            } else if let error = error {
                print("Error finding document to delete: \(error)")
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
        
        // Set callbacks
        cell.onEdit = { [weak self] in
            self?.navigateToEditReview(at: indexPath.row)
        }
        cell.onDelete = { [weak self] in
            self?.confirmDeleteReview(at: indexPath.row)
        }
        
        return cell
    }

}
