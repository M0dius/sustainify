//
//  NavigationManager.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

final class NavigationManager {

    // MARK: - Static Show Navigation
    static func show<T: UIViewController>(
        _ intent: NavigationIntent,
        on navigationController: UINavigationController?,
        animation: NavigationAnimation,
        configure: ((T) -> Void)? = nil
    ) {
        guard let navigationController = navigationController else {
            print("Error: NavigationController is nil. Cannot perform navigation.")
            return
        }

        // Instantiate the destination view controller
        guard let viewController = intent.viewController as? T else {
            print("Error: ViewController type mismatch.")
            return
        }

        // Configure the view controller (set delegates, data, etc.)
        configure?(viewController)

        // Perform navigation
        switch animation {
        case .push:
            push(viewController: viewController, on: navigationController)
        case .modal:
            present(viewController: viewController, on: navigationController)
        case .none:
            navigationController.setViewControllers([viewController], animated: false)
        }
    }

    // MARK: - Static Dismiss View
    static func dismiss(view: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if let navigationController = view.navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            view.dismiss(animated: animated, completion: completion)
        }
    }

    // MARK: - Private Static Helpers
    private static func push(viewController: UIViewController, on navigationController: UINavigationController) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    private static func present(viewController: UIViewController, on navigationController: UINavigationController) {
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
