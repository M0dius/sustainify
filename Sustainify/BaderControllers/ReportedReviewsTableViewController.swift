//
//  ReportedReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 29/12/2024.
//

//
//  ReportedReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 29/12/2024.
//

import UIKit
import Firebase

class ReportedReviewsTableViewController: UITableViewController {
    
    // Struct to hold reported review details
    struct ReportedReview {
        let id: String
        let title: String
        let content: String
        let rating: Int
        let username: String
        let timestamp: Timestamp
        let originalReviewID: String // ID of the review in the main "Reviews" collection
    }
    
    var reportedReviews: [ReportedReview] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reported Reviews"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        // Add Edit button to toggle table editing mode
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditingMode))
        
        // Add "All Reviews" button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "All Reviews", style: .plain, target: self, action: #selector(goToAllReviews))
        
        // Set the navigation bar background color
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        view.backgroundColor = .white
        
        fetchReportedReviewsFromFirestore()
    }
    
    @objc func goToAllReviews() {
        performSegue(withIdentifier: "showAllReviews", sender: self)
    }
    
    @objc func refreshReportedReviews() {
        // Fetch updated reported reviews from Firestore
        fetchReportedReviewsFromFirestore()
    }
    @IBAction func refreshReportedReveiws(_ sender: UIBarButtonItem) {
    }
    
    
    func fetchReportedReviewsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("ReportedReviews").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reported reviews: \(error)")
            } else {
                self.reportedReviews = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    let title = data["title"] as? String ?? "No title"
                    let content = data["content"] as? String ?? "No content"
                    let rating = data["rating"] as? Int ?? 0
                    let username = data["username"] as? String ?? "Unknown user"
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                    let originalReviewID = data["reviewID"] as? String ?? "" // The ID of the review in the "Reviews" collection
                    return ReportedReview(id: document.documentID, title: title, content: content, rating: rating, username: username, timestamp: timestamp, originalReviewID: originalReviewID)
                } ?? []
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func toggleEditingMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    func confirmDeleteReview(at index: Int) {
        let alert = UIAlertController(title: "Delete Reported Review", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteReview(at: index)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteReview(at index: Int) {
        let review = reportedReviews[index]
        let db = Firestore.firestore()
        
        // Delete from "ReportedReviews"
        db.collection("ReportedReviews").document(review.id).delete { error in
            if let error = error {
                print("Error deleting from ReportedReviews: \(error)")
            } else {
                print("Successfully deleted from ReportedReviews.")
                
                // Delete from "Reviews" if `originalReviewID` exists
                if !review.originalReviewID.isEmpty {
                    db.collection("Reviews").document(review.originalReviewID).delete { error in
                        if let error = error {
                            print("Error deleting from Reviews: \(error)")
                        } else {
                            print("Successfully deleted from Reviews.")
                        }
                    }
                }
                
                // Update local data and table view
                self.reportedReviews.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportedReviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportedReviewCell", for: indexPath) as? ReportedReviewCell else {
            fatalError("Unable to dequeue ReportedReviewCell")
        }
        
        let review = reportedReviews[indexPath.row]
        let formattedDate = DateFormatter.localizedString(from: review.timestamp.dateValue(), dateStyle: .medium, timeStyle: .short)
        
        // Configure the cell
        cell.titleLabel.text = review.title
        cell.ratingLabel.text = "Rating: \(review.rating) stars"
        cell.contentLabel.text = review.content
        cell.usernameLabel.text = "Reported by: \(review.username)"
        cell.timestampLabel.text = "Date: \(formattedDate)"
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllReviews" {
            if segue.destination is AllReviewsTableViewController {
                // Configure allReviewsVC if required
            }
        }
    }
}
