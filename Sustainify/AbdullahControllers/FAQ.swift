//
//  FAQ.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import Foundation

struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool
}

let faqItems: [FAQItem] = [
    FAQItem(question: "What is Sustainify?", answer: "Sustainify is an eco-friendly shopping assistant that helps you discover sustainable products and make environmentally conscious choices.", isExpanded: false),
    FAQItem(question: "How do I use Sustainify?", answer: "You can use Sustainify by browsing eco-friendly products, scanning items to check their environmental impact, or locating nearby stores that offer sustainable options.", isExpanded: false),
    FAQItem(question: "How do I order products?", answer: "You can order eco-friendly products directly through Sustainify by selecting items and following the guided checkout process.", isExpanded: false),
    FAQItem(question: "What is the Product Impact Tracker?", answer: "The Product Impact Tracker provides detailed information about a product's environmental impact, helping you make informed decisions.", isExpanded: false),
    FAQItem(question: "Are there any rewards for using Sustainify?", answer: "Sustainify offers rewards and incentives for sustainable shopping, such as discounts or eco-points for purchases.", isExpanded: false),
    FAQItem(question: "How do I scan a product?", answer: "You can scan a product's barcode using the Sustainify app to view detailed information about its sustainability and environmental impact.", isExpanded: false),
    FAQItem(question: "Can I save my favorite products?", answer: "Yes, Sustainify allows you to save your favorite eco-friendly products for easy access in the future.", isExpanded: false),
    FAQItem(question: "How do I update my account information?", answer: "You can update your account details, such as your name, or preferences, through the profile section of the app.", isExpanded: false),
    FAQItem(question: "Who created this app?", answer: "Sustainify was created as part of the \"Mobile Programming IT-8108\" course by Abdulla Alabbasi (202100158), Ali Norooz (202200961), Bader Ibrahim (202204342), Mohamed Alalawi (202202097), and Mohamed Ashoor (202200388).", isExpanded: false),
    FAQItem(question: "How do I contact customer support?", answer: "If you have any issues or questions, you can contact Sustainify's customer support through the app or website.", isExpanded: false)
]

