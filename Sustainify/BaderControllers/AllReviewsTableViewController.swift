//
//  AllReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 31/12/2024.
//

import UIKit
import Firebase

class AllReviewsTableViewController: UITableViewController {
    
    struct Review {
        let id: String
        let title: String
        let content: String
        let rating: Int
        let timestamp: Timestamp
        let userID: String
    }
    
    var reviews: [Review] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Reviews"
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
                    let id = document.documentID
                    let title = data["title"] as? String ?? "No title"
                    let content = data["content"] as? String ?? "No content"
                    let rating = data["rating"] as? Int ?? 0
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                    let userID = data["userID"] as? String ?? "Unknown user"
                    return Review(id: id, title: title, content: content, rating: rating, timestamp: timestamp, userID: userID)
                } ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    func reportReview(_ review: Review) {
        let db = Firestore.firestore()
        let reportedReviewData: [String: Any] = [
            "reviewID": review.id,
            "title": review.title,
            "content": review.content,
            "rating": review.rating,
            "timestamp": review.timestamp,
            "userID": review.userID
        ]
        db.collection("ReportedReviews").addDocument(data: reportedReviewData) { error in
            if let error = error {
                print("Error reporting review: \(error)")
            } else {
                print("Review successfully reported!")
                self.showAlert(message: "The review has been reported.")
            }
        }
    }
    
    func confirmReportReview(at index: Int) {
        let alert = UIAlertController(title: "Report Review", message: "Are you sure you want to report this review?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.reportReview(self.reviews[index])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllReviewsCell", for: indexPath) as? AllReviewsTableViewCell else {
            fatalError("Unable to dequeue AllReviewsCell")
        }
        
        let review = reviews[indexPath.row]
        cell.allReviewsTitle.text = review.title
        cell.allReviewsStars.text = "Rating: \(review.rating) stars"
        cell.allReviewsContent.text = review.content
        
        cell.onReport = { [weak self] in
            self?.confirmReportReview(at: indexPath.row)
        }
        
        return cell
    }
}
