//
//  Movie.swift
//  JSON
//
//  Created by 박세라 on 2022/03/10.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [MovieItem]
}

// MARK: - Item
struct MovieItem: Codable {
    let title: String
    let link: String
    let image: String
    let subtitle, pubDate, director, actor: String
    let userRating: String
}
