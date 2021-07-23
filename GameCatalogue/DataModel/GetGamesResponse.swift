//
//  GetGamesResponse.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import Foundation

struct GetGamesResponse: Codable {
    let count: Int
    let next, previous: String?
    let results: [GameItemResponse]
}

struct GameItemResponse: Codable {
    let id: Int
    let name, released: String
    let backgroundImage: String
    let rating: Double
    let ratingsCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
    }
}
