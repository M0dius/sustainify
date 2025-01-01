//
//  Double+Extension.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import Foundation

extension Double {
    func formattedAsCurrency() -> String {
        return String(format: "%.2f BD", self)
    }
}
