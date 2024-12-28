import Foundation

/// Represents an individual item within a store.
struct StoreItem {
    let name: String
    let price: String
    let imageName: String
    let category: String // Category (e.g., Food, Drinks, Clothing, etc.)
    let co2Emissions: Double // CO2 emissions score (lower is better)
    let recyclability: Double // Recyclability score (higher is better)
    let plasticWaste: Double // Plastic waste score (lower is better)
}

class Store {
    let name: String
    let detail: String
    let imageName: String
    let openingTime: String
    let closingTime: String
    
    // Items in the store
    let allStoreItems: [StoreItem]
    
    // Computed property: Most sustainable items
    var mostSustainableItems: [StoreItem] {
        return allStoreItems
            .sorted(by: { $0.sustainabilityScore < $1.sustainabilityScore })
            .prefix(5)
            .map { $0 }
    }
    
    init(
        name: String,
        detail: String,
        imageName: String,
        openingTime: String,
        closingTime: String,
        allStoreItems: [StoreItem]
    ) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.allStoreItems = allStoreItems
    }
}

extension StoreItem {
    var sustainabilityScore: Double {
        // Lower score is better
        (co2Emissions * 0.4) + ((1 - recyclability) * 0.3) + (plasticWaste * 0.3)
    }
}

class DataManager {
    static let shared = DataManager()
    
    let stores: [Store] = [
        Store(
            name: "IKEA",
            detail: "Best store in town for sustainable products",
            imageName: "IKEA",
            openingTime: "9:00 AM",
            closingTime: "9:00 PM",
            allStoreItems: [
                StoreItem(name: "Reusable Bottle", price: "$15.00", imageName: "BottleImage", category: "Toiletries", co2Emissions: 0.1, recyclability: 0.9, plasticWaste: 0.0),
                StoreItem(name: "Eco-Friendly Lamp", price: "$30.00", imageName: "LampImage", category: "Electronics", co2Emissions: 0.3, recyclability: 0.8, plasticWaste: 0.1),
                StoreItem(name: "Organic Cotton T-Shirt", price: "$25.00", imageName: "TShirtImage", category: "Clothing", co2Emissions: 0.2, recyclability: 0.7, plasticWaste: 0.0),
                StoreItem(name: "Bamboo Utensils Set", price: "$20.00", imageName: "BambooImage", category: "Food", co2Emissions: 0.1, recyclability: 0.95, plasticWaste: 0.0),
                StoreItem(name: "Steel Water Bottle", price: "$12.00", imageName: "SteelBottleImage", category: "Drinks", co2Emissions: 0.05, recyclability: 1.0, plasticWaste: 0.0),
                StoreItem(name: "Organic Juice", price: "$5.00", imageName: "JuiceImage", category: "Drinks", co2Emissions: 0.15, recyclability: 0.85, plasticWaste: 0.05),
                StoreItem(name: "Recyclable Shampoo Bottle", price: "$10.00", imageName: "ShampooImage", category: "Toiletries", co2Emissions: 0.2, recyclability: 0.9, plasticWaste: 0.1),
                StoreItem(name: "Foundation", price: "$10.00", imageName: "FoundationImage", category: "Makeup", co2Emissions: 0.3, recyclability: 0.7, plasticWaste: 0.2),
                StoreItem(name: "Reusable Shopping Bag", price: "$2.00", imageName: "BagImage", category: "Toiletries", co2Emissions: 0.05, recyclability: 1.0, plasticWaste: 0.0),
                StoreItem(name: "Wireless Headphones", price: "$50.00", imageName: "HeadphonesImage", category: "Electronics", co2Emissions: 0.5, recyclability: 0.4, plasticWaste: 0.2)
            ]
        )
    ]
}
