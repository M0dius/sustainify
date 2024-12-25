//
//  ReviewsTableViewController.swift
//  Sustainify
//
//  Created by Guest User on 15/12/2024.
//

import UIKit

class ReviewsTableViewController: UITableViewController {

    var reviews: [(title: String, content: String, rating: Int)] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Reviews"
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 80
            //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reviewCell")
        }
        
        // MARK: - Navigation to AddReviewViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddReview",
           let addReviewVC = segue.destination as? AddReviewViewController {
            
            // pass a callback to get the data back
            addReviewVC.onReviewAdded = { [weak self] title, content, rating in
                print("New Review Added - Title: \(title), Content: \(content), Rating: \(rating)") // debugging
                self?.reviews.append((title: title, content: content, rating: rating))
                print("Total Reviews: \(self?.reviews.count ?? 0)") // verify array count
                self?.tableView.reloadData()
            }
        }
    }

        
        // MARK: - TableView DataSource
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else {
            fatalError("Unable to dequeue ReviewTableViewCell")
        }

        let review = reviews[indexPath.row]
        cell.reviewLabel.text = "\(review.title)\n\(review.content)"
        cell.reviewLabel.numberOfLines = 0
        cell.updateStars(rating: review.rating)

        // Handle Edit action
        cell.onEdit = { [weak self] in
            self?.navigateToEditReview(at: indexPath.row)
        }
        
        // Handle Delete action
        cell.onDelete = { [weak self] in
            self?.confirmDeleteReview(at: indexPath.row)
        }
        
        return cell
    }



    
    func navigateToEditReview(at index: Int) {
        let review = reviews[index]
        if let addReviewVC = storyboard?.instantiateViewController(withIdentifier: "AddReviewViewController") as? AddReviewViewController {
            addReviewVC.editingReviewIndex = index
            addReviewVC.initialTitle = review.title
            addReviewVC.initialContent = review.content
            addReviewVC.currentRating = review.rating // Pass the current rating to the editing view

            addReviewVC.onReviewAdded = { [weak self] title, content, rating in
                self?.reviews[index] = (title: title, content: content, rating: rating)
                self?.tableView.reloadData()
            }
            navigationController?.pushViewController(addReviewVC, animated: true)
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

    func deleteReview(at index: Int) {
        reviews.remove(at: index)
        tableView.reloadData()
    }


}
