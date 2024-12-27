import Foundation
import UIKit  // Add this to store UIImage in the struct if you haven't already

struct Shop {
    var name: String
    var crNumber: Int
    var building: Int
    var road: Int
    var block: Int
    var openingTime: Date?
    var closingTime: Date?
    var minimumOrderAmount: Double?  // New field for minimum order amount
    
    // Store categories array
    var storeCategories: [String] = []
    
    // Store image
    var storeImage: UIImage?
}
