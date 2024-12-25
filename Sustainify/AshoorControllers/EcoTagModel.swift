import Foundation

enum EcoTag: String, CaseIterable {
    case CO2ePer100g = "CO₂e per 100g of product"
    case waterSaved = "Water saved"
    case recycledMaterial = "Recycled material"
}

struct EcoTagModel {
    var tag: EcoTag
    var value: String?  // Value entered by the user
}
