//
//  TabItem.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import UIKit

enum TabItem: String, CaseIterable {
    case home = "Home"
    case orders = "Orders"
    case impactTracker = "PIT"
    case account = "Account"

    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .orders:
            return UIImage(systemName: "list.clipboard")
        case .impactTracker:
            return UIImage(systemName: "globe.americas.fill")
        case .account:
            return UIImage(systemName: "person")
        }
    }

    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .orders:
            return OrdersViewController()
        case .impactTracker:
            return ImpactTrackerNavigationIntent().viewController
        case .account:
            return AccountViewController()
        }
    }
}
