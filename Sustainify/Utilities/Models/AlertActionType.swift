//
//  AlertActionType.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation
import UIKit

enum AlertActionType {
    case ok
    case cancel
    case destructive
    case custom(title: String, style: UIAlertAction.Style)

    var title: String {
        switch self {
        case .ok:
            return "OK"
        case .cancel:
            return "Cancel"
        case .destructive:
            return "Delete"
        case .custom(let title, _):
            return title
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .ok:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case .custom(_, let style):
            return style
        }
    }
}
