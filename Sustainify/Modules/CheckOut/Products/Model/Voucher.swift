//
//  Voucher.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 31/12/24.
//

import Foundation

struct Voucher {
    let id: String
    let code: String
    let discount: Double
    let expiryDate: String
    let status: String

    static func fromDictionary(_ data: [String: Any]) -> Voucher? {
        guard
            let code = data["code"] as? String,
            let discount = data["discount"] as? Double,
            let expiryDate = data["expiryDate"] as? String,
            let status = data["status"] as? String
        else {
            return nil
        }
        return Voucher(
            id: data["id"] as? String ?? UUID().uuidString,
            code: code,
            discount: discount,
            expiryDate: expiryDate,
            status: status
        )
    }
}
