//
//  MapperUtil.swift
//  GameCatalogue
//
//  Created by Team SSG on 30/07/21.
//

import Foundation

class MapperUtil {

    static func mapResponseToGameModel(gameResponses: [GameItemResponse]) -> [GameModel] {
        return gameResponses.map { itemResponse in
            GameModel(gameId: itemResponse.gameId, name: itemResponse.name, released: itemResponse.released, image: itemResponse.backgroundImage, rating: itemResponse.rating, ratingsCount: itemResponse.ratingsCount, description: "")}
    }
}
