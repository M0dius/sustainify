//
//  FAQViewController.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import UIKit

class FAQViewController: UITableViewController {

    var faqItems: [FAQItem] = [
        FAQItem(question: "What is Sustainify?", answer: "Sustainify is an eco-friendly shopping assistant that helps you make environmentally friendly choices!", isExpanded: false),
        FAQItem(question: "How do I use Sustainify?", answer: "You can use Sustainify for eco-friendly products, scanning items for their enviromental impact, or locating stores offering sustainable options.", isExpanded: false),
        FAQItem(question: "How do I order products?", answer: "You can order products through Sustainify by selecting items and following the guided checkout process.", isExpanded: false),
        FAQItem(question: "What is the Product Impact Tracker?", answer: "The Product Impact Tracker (PIT) provides detailed information about a product's environmental impact, helping you make informed decisions.", isExpanded: false),
        FAQItem(question: "Are there rewards for using Sustainify?", answer: "Sustainify offers rewards and incentives for sustainable shopping, such as discounts or eco-points for purchases.", isExpanded: false),
        FAQItem(question: "How do I scan a product?", answer: "You can scan a product's barcode using the Sustainify app to view detailed information about its sustainability and environmental impact.", isExpanded: false),
        FAQItem(question: "Can I save my favorite products?", answer: "Yes, Sustainify allows you to save your favorite eco-friendly products for easy access in the future.", isExpanded: false),
        FAQItem(question: "How do I update my information?", answer: "You can update your account details, such as your name, or preferences, through the profile section of the app.", isExpanded: false),
        FAQItem(question: "Who created this app?", answer: "Created for the \"Mobile Programming IT-8108\" course by Abdulla Alabbasi (202100158), Ali Norooz, Bader Ibrahim, Mohamed Alalawi, Mohamed Ashoor.", isExpanded: false),
        FAQItem(question: "How do I contact customer support?", answer: "If you have any issues or questions, you can contact Sustainify's customer support through the app or website.", isExpanded: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        
        // Enable dynamic cell resizing
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80 // Adjusted for better readability when collapsed
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell and cast it to FAQCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as? FAQCell else {
            fatalError("Failed to dequeue FAQCell")
        }

        // Get the FAQ item
        let faqItem = faqItems[indexPath.row]
        
        // Configure the cell's labels
        cell.questionLabel.text = faqItem.question
        cell.answerLabel.text = faqItem.answer
        
        // Set dynamic number of lines for both question and answer
        cell.questionLabel.numberOfLines = 0
        cell.answerLabel.numberOfLines = faqItem.isExpanded ? 0 : 1
        
        // If expanded, show the answer content; otherwise, collapse the answer label
        cell.answerLabel.isHidden = !faqItem.isExpanded

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle the expanded state of the selected FAQ item
        faqItems[indexPath.row].isExpanded.toggle()

        // Reload the selected row with animation
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // Override this method to dynamically calculate row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let faqItem = faqItems[indexPath.row]

        // Return height based on whether the answer is expanded or not
        if faqItem.isExpanded {
            return UITableView.automaticDimension
        } else {
            return 80 // Default height when collapsed (showing only the question)
        }
    }

    // To fix layout issue when collapsing rows
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Make sure to reset layout after expansion/collapse
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
