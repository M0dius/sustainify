//
//  Tag.swift
//  Sustainify
//
//  Created by Guest User on 12/12/2024.
//

import Foundation

struct Tag {
    var name: String
    var description: String
}

struct Review {
    let title: String
    let content: String
    let rating: Int

    func toAnyObject() -> [String: Any] {
        return [
            "title": title,
            "content": content,
            "rating": rating
        ]
    }
}

extension Tag {
    static let mockTags: [Tag] = [
        Tag(name: "Eco Score", description: "This product has an eco score based on sustainability."),
        Tag(name: "Organic", description: "This product is made from organic ingredients."),
        Tag(name: "Fair Trade", description: "This product is certified fair trade.")
    ]
}
