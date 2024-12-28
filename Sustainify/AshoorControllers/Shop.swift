import Foundation
import UIKit  // Add this to store UIImage in the struct if you haven't already

struct Shop {
    var name: String
    var crNumber: Int
    var building: Int
    var road: Int
    var block: Int
    var openingTime: String? // Changed to String
    var closingTime: String? // Changed to String
    var minimumOrderAmount: Double?
    var storeCategories: [String]
    var storeImage: UIImage?
    var paymentOptions: [String]
}