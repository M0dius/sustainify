//
//  structs.swift
//  Sustainify
//
//  Created by Guest User on 05/12/2024.
//

import Foundation

//var myDict = ["Food": false, "Drink": false, "Makeup": false, "Toiletries": false, "Clothing": false, "Other": false, "Electronics": false]

struct ecoTagApplied {
    var applied: Bool
    var name: String
    var weight: Int
    
}

struct nonAppProd {
    var name: String
    var company: String
    var categories: [String: Bool] = [:]
    
    //create init function with guard to only allow select categories
}

