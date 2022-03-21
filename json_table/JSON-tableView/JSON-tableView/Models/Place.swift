//
//  Place.swift
//  JSON
//
//  Created by 박세라 on 2022/03/10.
//

import Foundation

// MARK: - Place
struct Place: Codable {
    let total: Int
    let items: [Item]
    let lastBuildDate: String
    let start, display: Int
}

// MARK: - Item
struct Item: Codable {
    let link: String
    let mapy, roadAddress, title, mapx: String
    let address, itemDescription, category, telephone: String

    enum CodingKeys: String, CodingKey {
        case link, mapy, roadAddress, title, mapx, address
        case itemDescription = "description"
        case category, telephone
    }
}
