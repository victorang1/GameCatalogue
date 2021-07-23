//
//  DetailResponse.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import Foundation

struct DetailResponse: Codable {
    let gameId: Int
    let slug, name, nameOriginal, detailResponseDescription: String
    let released: String
    let tba: Bool
    let updated: String
    let backgroundImage: String
    let backgroundImageAdditional: String
    let website: String
    let rating: Double
    let ratingTop: Int
    let ratingsCount: Int
    let platforms: [Platform]

    enum CodingKeys: String, CodingKey {
        case gameId = "id"
        case slug, name
        case nameOriginal = "name_original"
        case detailResponseDescription = "description"
        case released, tba, updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case ratingTop = "rating_top"
        case ratingsCount = "ratings_count"
        case platforms
    }
}

// MARK: - Platform
struct Platform: Codable {
    let platform: EsrbRating
    let releasedAt: String?
    let requirements: Requirements = Requirements(minimum: "", recommended: "")

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

struct EsrbRating: Codable {
    let platformId: Int
    let slug, name: String
    let imageBackground: String

    enum CodingKeys: String, CodingKey {
        case platformId = "id"
        case slug, name
        case imageBackground = "image_background"
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum, recommended: String
}
