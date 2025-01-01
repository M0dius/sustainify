//
//  structs.swift
//  Sustainify
//
//  Created by Guest User on 05/12/2024.
//

import Foundation

enum CategoryName {
    case food, drink, makeup, toiletries, clothing, other, electronics
}

enum TagName {
    case co2Em, h2oSaved, recyMat
}

//enum Barcode {
//    case upc(Int, Int, Int, Int)
//}

//make sure the fetch/save functions validate this data
class UpcBarcode {
    var numberSystem: Int
    var manufacturer: Int
    var product: Int
    var check: Int
    
    init(numberSystem: Int, manufacturer: Int, product: Int, check: Int) {
        self.numberSystem = numberSystem
        self.manufacturer = manufacturer
        self.product = product
        self.check = check
    }
}

class EcoTag {
    var applied: Bool
    var name: TagName
    var weight: Int?

    init(applied: Bool, name: TagName, weight: Int?) {
        self.applied = applied
        self.name = name
        self.weight = weight
    }
}

class NonAppItem: Identifiable {
    let id = UUID()
    var name: String
    var company: String
    var categories: [CategoryName] = []
    var ecoTags: [EcoTag]

    init(name: String, company: String, categories: [CategoryName], ecoTags: [EcoTag]) {
        self.name = name
        self.company = company
        self.categories = categories
        self.ecoTags = ecoTags
    }
}
