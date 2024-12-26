//
//  DataManager.swift
//  Sustainify
//

import Foundation

/// Represents an individual item within a store.
struct StoreItem {
    let name: String
    let price: String
    let imageName: String
}

/// Represents a store with basic info, plus arrays for dropdown items and best-selling items.
class Store {
    let name: String
    let detail: String
    let imageName: String
    let openingTime: String
    let closingTime: String
    
    // For the dropdown search
    let items: [String]
    
    // For the "Best Selling Items" section
    let bestSellingItems: [StoreItem]
    
    init(
        name: String,
        detail: String,
        imageName: String,
        openingTime: String,
        closingTime: String,
        items: [String],
        bestSellingItems: [StoreItem]
    ) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.items = items
        self.bestSellingItems = bestSellingItems
    }
    
    var formattedOpeningTime: String {
        return "Opens \(openingTime)"
    }
    
    var formattedClosingTime: String {
        return "Closes \(closingTime)"
    }
}

/// Our shared manager containing dummy data for stores.
/// Later, you can replace or connect to a real database.
class DataManager: NSObject {
    static let shared = DataManager()
    
    // Dummy data for demonstration
    let stores: [Store] = [
        Store(
            name: "IKEA",
            detail: "Best store in town",
            imageName: "IKEA",
            openingTime: "9:00 AM",
            closingTime: "9:00 PM",
            items: ["Item 1", "Item 2", "EcoLamp", "GreenChair"],
            bestSellingItems: [
                StoreItem(name: "Folding Chair", price: "$14.99", imageName: "ChairImage"),
                StoreItem(name: "Eco-Friendly Lamp", price: "$29.99", imageName: "LampImage"),
                StoreItem(name: "Bamboo Table", price: "$49.99", imageName: "TableImage")
            ]
        ),
        Store(
            name: "Walmart",
            detail: "Quality products",
            imageName: "Walmart",
            openingTime: "10:00 AM",
            closingTime: "8:00 PM",
            items: ["Grocery Bag", "Organic Milk"],
            bestSellingItems: [
                StoreItem(name: "Reusable Bag", price: "$1.99", imageName: "BagImage"),
                StoreItem(name: "Organic Milk", price: "$3.49", imageName: "MilkImage")
            ]
        )
    ]
}
