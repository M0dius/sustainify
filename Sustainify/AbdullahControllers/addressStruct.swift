//
//  addressStruct.swift
//  Sustainify
//
//  Created by Guest User on 28/12/2024.
//

import Foundation

struct Address {
    var id: String
    var address: String
    var addressType: String
    var house: Int
    var block: Int
    var road: Int
    var phoneNumber: Int
    var apartmentNumber: Int
    var building: Int
    var floor: Int
    var company: String
    var officeNumber: Int

    init(id: String, address: String, addressType: String, house: Int, block: Int, road: Int, phoneNumber: Int, apartmentNumber: Int, building: Int, floor: Int, company: String, officeNumber: Int) {
        self.id = id
        self.address = address
        self.addressType = addressType
        self.house = house
        self.block = block
        self.road = road
        self.phoneNumber = phoneNumber
        self.apartmentNumber = apartmentNumber
        self.building = building
        self.floor = floor
        self.company = company
        self.officeNumber = officeNumber
    }
}
