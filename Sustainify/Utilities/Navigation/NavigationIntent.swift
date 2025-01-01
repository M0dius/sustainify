//
//  NavigationIntent.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

protocol NavigationIntent {
    var storyboard: Storyboard { get }
    var storyboardID: StoryboardID { get }
    var viewController: UIViewController { get }
}

extension NavigationIntent {
    var viewController: UIViewController {
        return UIViewController.instantiate(from: storyboard, with: storyboardID)
    }
}

// MARK: - Navigation Intents
struct ImpactTrackerNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .pit }
    var storyboardID: StoryboardID { return .impactTracker }
}

struct NonAppTableNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .pit }
    var storyboardID: StoryboardID { return .nonAppProducts }
}

struct AddProductNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .pit }
    var storyboardID: StoryboardID { return .addProduct }
}

struct ProductDetailNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .checkOut }
    var storyboardID: StoryboardID { return .productDetail }
}

struct CartNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .checkOut }
    var storyboardID: StoryboardID { return .cart }
}

struct CheckOutNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .checkOut }
    var storyboardID: StoryboardID { return .checkOut }
}

struct ProductsNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .checkOut }
    var storyboardID: StoryboardID { return .products }
}
struct DeliveryNavigationIntent: NavigationIntent {
    var storyboard: Storyboard { return .checkOut }
    var storyboardID: StoryboardID { return .delivery }
}






