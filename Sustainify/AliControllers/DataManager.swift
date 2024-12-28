import Foundation

/// Represents an individual item within a store.
struct StoreItem {
    let name: String
    let price: String
    let imageName: String
    let category: String
    let ecoScore: Int // A higher score indicates more eco-friendliness
}

class Store {
    let name: String
    let detail: String
    let imageName: String
    let openingTime: String
    let closingTime: String
    let items: [String]
    let allStoreItems: [StoreItem]
    
    /// Dynamically fetches the top 6 most eco-friendly items.
    var mostSustainableItems: [StoreItem] {
        return allStoreItems
            .sorted { $0.ecoScore > $1.ecoScore } // Sort by highest ecoScore
            .prefix(6) // Limit to 6 items
            .map { $0 }
    }
    
    init(
        name: String,
        detail: String,
        imageName: String,
        openingTime: String,
        closingTime: String,
        items: [String],
        allStoreItems: [StoreItem]
    ) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.items = items
        self.allStoreItems = allStoreItems
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
            allStoreItems: [
                StoreItem(name: "Steel Water Bottle",
                          price: "$10.00",
                          imageName: "SteelBottleImage",
                          category: "Drinks",
                          ecoScore: 100),
                StoreItem(name: "Plastic Water Bottle",
                          price: "$1.00",
                          imageName: "PlasticBottleImage",
                          category: "Drinks",
                          ecoScore: 20),
                StoreItem(name: "Reusable Grocery Bag",
                          price: "$2.00",
                          imageName: "ReusableBagImage",
                          category: "Toiletries",
                          ecoScore: 90),
                StoreItem(name: "Eco-Friendly Lamp",
                          price: "$29.99",
                          imageName: "LampImage",
                          category: "Furniture",
                          ecoScore: 85),
                StoreItem(name: "Bamboo Table",
                          price: "$49.99",
                          imageName: "TableImage",
                          category: "Furniture",
                          ecoScore: 70),
                StoreItem(name: "Lipstick Set",
                          price: "$12.99",
                          imageName: "LipstickImage",
                          category: "Makeup",
                          ecoScore: 10),
                StoreItem(name: "Organic Cotton T-Shirt",
                          price: "$25.00",
                          imageName: "CottonTShirtImage",
                          category: "Clothing",
                          ecoScore: 95),
                StoreItem(name: "Recycled Notebook",
                          price: "$5.00",
                          imageName: "NotebookImage",
                          category: "Stationery",
                          ecoScore: 80)
            ]
        )
    ]
}
