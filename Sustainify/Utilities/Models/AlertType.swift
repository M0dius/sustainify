//
//  AlertType.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import Foundation

enum AlertType {
    case deleteAll
    case custom(title: String, message: String?)
    case titleOnly(title: String)

    var title: String {
        switch self {
        case .deleteAll:
            return "Delete All Items"
        case .custom(let title, _):
            return title
        case .titleOnly(let title):
            return title
        }
    }

    var message: String? {
        switch self {
        case .deleteAll:
            return "Are you sure you want to delete all items?"
        case .custom(_, let message):
            return message
        case .titleOnly:
            return nil
        }
    }
}
