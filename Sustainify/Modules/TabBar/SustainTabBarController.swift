//
//  SustainTabBarController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

class SustainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeAppearance()
    }
    
    private func setupTabBar() {
        let controllers = TabItem.allCases.map { createNavController(for: $0.viewController, title: $0.rawValue, image: $0.image) }
        viewControllers = controllers
    }
    
    private func customizeAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = nil
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        // Tint colors
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .systemGreen
        tabBar.layer.borderWidth = 0.5
    }
        
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = false
        
        // Set navigation appearance
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .appGreen
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.standardAppearance = navAppearance
        navController.navigationBar.scrollEdgeAppearance = navAppearance
        navController.navigationBar.tintColor = .black        
        // Set tab bar item
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
}

// MARK: - View Controllers
class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBlue
    }
}

class OrdersViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemYellow
    }
}

class AccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemPink
    }
}
