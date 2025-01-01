//
//  Date+Extension.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 31/12/24.
//

import Foundation

extension Date {
    /// Checks if the current date is before or equal to a specified date.
    /// - Parameter comparisonDate: The date to compare with.
    /// - Returns: `true` if the current date is before or equal to the specified date, otherwise `false`.
    func isBeforeOrEqual(to comparisonDate: Date) -> Bool {
        return self <= comparisonDate
    }
    
    /// Converts a `Date` to a string using the specified date format.
    /// - Parameter format: The date format, e.g., "dd/MM/yyyy".
    /// - Returns: A formatted date string.
    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
