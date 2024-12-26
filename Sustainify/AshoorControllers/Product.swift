import Foundation
import UIKit

struct Product {
    var name: String
    var company: String
    var price: Double
    var description: String
    var ecoScore: Int
    var categories: [String]
    var ecoTags: [EcoTagModel]
    var image: UIImage?  // New property for the product image
}
