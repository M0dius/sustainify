import Foundation

class DataManager: NSObject {
    static let shared = DataManager()
    
    let stores: [Store] = [
        // Consolidated store data here
        Store(
            name: "IKEA",
            detail: "Best store in town",
            imageName: "IKEA",
            openingTime: "9:00 AM",
            closingTime: "9:00 PM",
            items: ["Item 1", "Item 2"]
        ),
        Store(
            name: "Walmart",
            detail: "Quality products",
            imageName: "Walmart",
            openingTime: "10:00 AM",
            closingTime: "8:00 PM",
            items: ["Item 3", "Item 4"]
        )
    ]
}

class Store {
    let name: String
    let detail: String
    let imageName: String
    let openingTime: String
    let closingTime: String
    let items: [String]
    
    init(
        name: String,
        detail: String,
        imageName: String,
        openingTime: String,
        closingTime: String,
        items: [String]
    ) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.items = items
    }
    
    var formattedOpeningTime: String {
        return "Opens \(openingTime)"
    }
    
    var formattedClosingTime: String {
        return "Closes \(closingTime)"
    }
}
