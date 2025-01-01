//
//  PaymentMethod.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import Foundation

// MARK: - PaymentMethod 
enum PaymentMethod: String, CaseIterable {
    case cash = "Cash"
    case benefit = "Benefit"
    case online = "Online"

    func getDescription() -> String {
        switch self {
        case .cash:
            return "Cash on delivery"
        case .benefit:
            return "Benefit on delivery"
        case .online:
            return "Online payment (debit/credit card)"
        }
    }
}
