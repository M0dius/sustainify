//
//  Address.swift
//  Sustainify
//
//  Created by Guest User on 27/12/2024.
//

import Foundation
import FirebaseFirestore

enum AddressType: String {
    case house = "House"
    case apartment = "Apartment"
    case office = "Office"
}

struct Address: Codable {
    @DocumentID var id: String? // Firestore document ID
    var addressType: AddressType
    var house: String?
    var block: String?
    var road: String?
    var phoneNumber: String?
    
    // For Apartment
    var apartmentNumber: String?
    var building: String?
    var floor: String?
    
    // For Office
    var company: String?
    var officeNumber: String?

    // Custom initializers for different types of addresses
    init(house: String, block: String, road: String, phoneNumber: String) {
        self.addressType = .house
        self.house = house
        self.block = block
        self.road = road
        self.phoneNumber = phoneNumber
    }
    
    init(apartmentNumber: String, building: String, floor: String, block: String, road: String, phoneNumber: String) {
        self.addressType = .apartment
        self.apartmentNumber = apartmentNumber
        self.building = building
        self.floor = floor
        self.block = block
        self.road = road
        self.phoneNumber = phoneNumber
    }
    
    init(company: String, building: String, floor: String, officeNumber: String, block: String, road: String, phoneNumber: String) {
        self.addressType = .office
        self.company = company
        self.building = building
        self.floor = floor
        self.officeNumber = officeNumber
        self.block = block
        self.road = road
        self.phoneNumber = phoneNumber
    }
}

