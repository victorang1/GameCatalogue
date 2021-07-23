//
//  MovieNetworkManager.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<GameService> { get }
    
    func fetchListGames(completion: @escaping (Result<GetGamesResponse, Error>) -> ())
    func fetchDetailGame(gameId: String, completion: @escaping (Result<DetailResponse, Error>) -> ())
    func searchGames(query: String, completion: @escaping (Result<GetGamesResponse, Error>) -> ())
}

class GameNetworkManager: Networkable {
    var provider = MoyaProvider<GameService>(plugins: [NetworkLoggerPlugin()])
    
    func fetchListGames(completion: @escaping (Result<GetGamesResponse, Error>) -> ()) {
        request(target: .games, completion: completion)
    }
    
    func fetchDetailGame(gameId: String, completion: @escaping (Result<DetailResponse, Error>) -> ()) {
        request(target: .detail(gameId: gameId), completion: completion)
    }
    
    func searchGames(query: String, completion: @escaping (Result<GetGamesResponse, Error>) -> ()) {
        request(target: .search(query: query), completion: completion)
    }
}

private extension GameNetworkManager {
    
    private func request<T: Decodable>(target: GameService, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
