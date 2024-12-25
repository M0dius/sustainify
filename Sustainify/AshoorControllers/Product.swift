import Foundation

struct Product {
    var name: String
    var company: String
    var price: Double
    var description: String
    var ecoScore: Int
    var categories: [String]
    var ecoTags: [EcoTagModel]  // New property for Eco-Tags
}
