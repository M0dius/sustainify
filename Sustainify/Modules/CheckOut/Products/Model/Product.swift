//
//  Product.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 30/12/24.
//

import Foundation

struct Product: Hashable {
    let id: String
    let name: String
    let price: Double
    let ecoTags: [String]
    let description: String
    let storeId: String

    static func fromDictionary(_ data: [String: Any]) -> Product? {
        guard
            let id = data["id"] as? String,
            let name = data["name"] as? String,
            let price = data["price"] as? Double,
            let ecoTags = data["ecoTags"] as? [String],
            let description = data["description"] as? String,
            let storeId = data["storeId"] as? String
        else {
            return nil
        }
        return Product(id: id, name: name, price: price, ecoTags: ecoTags, description: description, storeId: storeId)
    }
}

extension Product {
    func mapToDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "price": price,
            "ecoTags": ecoTags,
            "description": description,
            "storeId": storeId
        ]
    }
    
    static func generateMockProducts(storeId: String) -> [Product] {
        return [
            Product(id: UUID().uuidString, name: "Bag", price: 0.300, ecoTags: ["Recycled"], description: "Eco-friendly bag made of recycled materials.", storeId: storeId),
            Product(id: UUID().uuidString, name: "Juice", price: 0.750, ecoTags: ["Water Saving"], description: "Organic juice with sustainable packaging.", storeId: storeId),
            Product(id: UUID().uuidString, name: "Bottles Set", price: 1.250, ecoTags: ["Recycled"], description: "Reusable bottles made from recycled materials.", storeId: storeId),
            Product(id: UUID().uuidString, name: "Furniture Set", price: 6.500, ecoTags: ["Eco-Friendly"], description: "Handcrafted furniture made with sustainable materials.", storeId: storeId),
            Product(id: UUID().uuidString, name: "Fox Toy", price: 0.500, ecoTags: ["Recycled"], description: "Eco-friendly toy made of recycled wood.", storeId: storeId)
        ]
    }
}
