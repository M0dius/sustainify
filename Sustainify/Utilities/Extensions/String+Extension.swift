//
//  String+Extension.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 31/12/24.
//

import Foundation

extension String {
    /// Converts a string to a `Date` using the specified date format.
    /// - Parameter format: The date format, e.g., "dd/MM/yyyy".
    /// - Returns: A `Date` object if the string can be successfully parsed, otherwise `nil`.
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
