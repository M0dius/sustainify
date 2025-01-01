//
//  Store.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import Foundation

struct RetailStore {
    let id: String
    let name: String
    let paymentOptions: [String]
    let deliveryFee: Double

    static func fromDictionary(_ data: [String: Any]) -> RetailStore? {
        guard
            let name = data["name"] as? String,
            let paymentOptions = data["paymentOptions"] as? [String],
            let deliveryFee = data["deliveryFee"] as? Double
        else {
            return nil
        }
        return RetailStore(
            id: data["id"] as? String ?? UUID().uuidString,
            name: name,
            paymentOptions: paymentOptions,
            deliveryFee: deliveryFee
        )
    }
}

extension RetailStore {
    func mapToDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "paymentOptions": paymentOptions,
            "deliveryFee": deliveryFee
        ]
    }
    
    static func generateMockStores() -> [RetailStore] {
        return [
            RetailStore(id: UUID().uuidString, name: "EcoMart", paymentOptions: ["Cash", "Card", "Online"], deliveryFee: 5.0),
            RetailStore(id: UUID().uuidString, name: "GreenGrocer", paymentOptions: ["Cash", "Benefit", "Online"], deliveryFee: 3.5),
            RetailStore(id: UUID().uuidString, name: "SustainShop", paymentOptions: ["Card", "Online"], deliveryFee: 4.0)
        ]
    }
}
