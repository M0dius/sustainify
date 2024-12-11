//
//  structs.swift
//  Sustainify
//
//  Created by Guest User on 05/12/2024.
//

import Foundation

enum CategoryName {
    case Food
    case Drink
    case Makeup
    case Toiletries
    case Clothing
    case Other
    case Electronics
}

enum TagName {
    case co2Em
    case o2Saved
    case recyMat
}

//enum Barcode {
//    case upc(Int, Int, Int, Int)
//}

//make sure the fetch/save functions validate this data
struct upcBarcode {
    var numberSystem: Int
    var manufacturer: Int
    var product: Int
    var check: Int
}

//make sure the fetch/save functions validate this data
struct ecoTag {
    var applied: Bool
    var name: TagName
    var weight: Int
}

//make sure the fetch/save functions validate this data
struct nonAppProd {
    var name: String
    var company: String
    var categories: [CategoryName: Bool] = [:]
    var ecoTags: [ecoTag]
    //var barcode: upcBarcode
    
    init(name: String, company: String, categories: [CategoryName : Bool], ecoTags: [ecoTag]) {
        self.name = name
        self.company = company
        self.categories = categories
        self.ecoTags = ecoTags
    }
}
