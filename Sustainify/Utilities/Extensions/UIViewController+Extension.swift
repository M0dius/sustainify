//
//  UIViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiate(from storyboard: Storyboard, with identifier: StoryboardID) -> Self {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? Self else {
            fatalError("Unable to instantiate \(identifier.rawValue) from \(storyboard) storyboard.")
        }
        return viewController
    }
    
    func showAlert(
        ofType type: AlertType,
        actions: [(AlertActionType, (() -> Void)?)]
    ) {
        let alert = UIAlertController(
            title: type.title,
            message: type.message,
            preferredStyle: .alert
        )

        for (actionType, handler) in actions {
            let alertAction = UIAlertAction(title: actionType.title, style: actionType.style) { _ in
                handler?()
            }
            alert.addAction(alertAction)
        }

        present(alert, animated: true, completion: nil)
    }

}
