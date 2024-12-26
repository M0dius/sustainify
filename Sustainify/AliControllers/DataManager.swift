import Foundation

/// Represents an individual item within a store.
struct StoreItem {
    let name: String
    let price: String
    let imageName: String
    let category: String // NEW: category (e.g., Food, Drinks, Clothing, etc.)
}

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
    
    // For the "All Items" section, let's store them separately or
    // we can reuse the bestSellingItems array if it’s the same items.
    // But we'll assume we have a bigger set of all items.
    let allStoreItems: [StoreItem] // We'll display these in the new section
    
    init(
        name: String,
        detail: String,
        imageName: String,
        openingTime: String,
        closingTime: String,
        items: [String],
        bestSellingItems: [StoreItem],
        allStoreItems: [StoreItem]
    ) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.items = items
        self.bestSellingItems = bestSellingItems
        self.allStoreItems = allStoreItems
    }
    
    var formattedOpeningTime: String {
        return "Opens \(openingTime)"
    }
    
    var formattedClosingTime: String {
        return "Closes \(closingTime)"
    }
}

class DataManager: NSObject {
    static let shared = DataManager()
    
    let stores: [Store] = [
        Store(
            name: "IKEA",
            detail: "Best store in town",
            imageName: "IKEA",
            openingTime: "9:00 AM",
            closingTime: "9:00 PM",
            items: ["Item 1", "Item 2", "EcoLamp", "GreenChair"],
            bestSellingItems: [
                StoreItem(name: "Folding Chair",
                          price: "$14.99",
                          imageName: "ChairImage",
                          category: "Furniture"),
                StoreItem(name: "Eco-Friendly Lamp",
                          price: "$29.99",
                          imageName: "LampImage",
                          category: "Furniture"),
                StoreItem(name: "Bamboo Table",
                          price: "$49.99",
                          imageName: "TableImage",
                          category: "Furniture")
            ],
            allStoreItems: [
                // Some random items covering multiple categories
                StoreItem(name: "Salad Bowl",
                          price: "$7.99",
                          imageName: "SaladBowlImage",
                          category: "Food"),
                StoreItem(name: "Organic Juice",
                          price: "$2.49",
                          imageName: "JuiceImage",
                          category: "Drinks"),
                StoreItem(name: "Lipstick Set",
                          price: "$12.99",
                          imageName: "LipstickImage",
                          category: "Makeup"),
                StoreItem(name: "T-Shirt",
                          price: "$15.00",
                          imageName: "TShirtImage",
                          category: "Clothing"),
                StoreItem(name: "Shampoo",
                          price: "$4.50",
                          imageName: "ShampooImage",
                          category: "Toiletries"),
                StoreItem(name: "Headphones",
                          price: "$29.00",
                          imageName: "HeadphonesImage",
                          category: "Electronics")
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
                StoreItem(name: "Reusable Bag",
                          price: "$1.99",
                          imageName: "BagImage",
                          category: "Toiletries"),
                StoreItem(name: "Organic Milk",
                          price: "$3.49",
                          imageName: "MilkImage",
                          category: "Food")
            ],
            allStoreItems: [
                // Another random set
                StoreItem(name: "Sandwich",
                          price: "$2.99",
                          imageName: "SandwichImage",
                          category: "Food"),
                StoreItem(name: "Water Bottle",
                          price: "$1.00",
                          imageName: "WaterBottleImage",
                          category: "Drinks"),
                StoreItem(name: "Foundation",
                          price: "$10.00",
                          imageName: "FoundationImage",
                          category: "Makeup"),
                StoreItem(name: "Jeans",
                          price: "$25.00",
                          imageName: "JeansImage",
                          category: "Clothing"),
                StoreItem(name: "Toothpaste",
                          price: "$2.50",
                          imageName: "ToothpasteImage",
                          category: "Toiletries"),
                StoreItem(name: "Smartphone Cable",
                          price: "$7.99",
                          imageName: "CableImage",
                          category: "Electronics")
            ]
        )
    ]
}
