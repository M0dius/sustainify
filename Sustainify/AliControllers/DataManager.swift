import Foundation

class DataManager: NSObject {
    static let shared = DataManager()
    
    let stores: [Store] = [
        Store(name: "IKEA", detail: "Furniture", imageName: "IKEA", openingTime: "09:00 AM", closingTime: "09:00 PM", items: ["Product 1", "Product 2", "Product 3"]),
        Store(name: "Walmart", detail: "Groceries", imageName: "Walmart", openingTime: "08:00 AM", closingTime: "10:00 PM", items: ["Product 4", "Product 5", "Product 6"])
    ]
}

class Store {
    let name: String
    let detail: String
    let imageName: String
    let openingTime: String
    let closingTime: String
    let items: [String]
    
    init(name: String, detail: String, imageName: String, openingTime: String, closingTime: String, items: [String]) {
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
