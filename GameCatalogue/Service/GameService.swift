//
//  MovieService.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import Foundation
import Moya

public enum GameService {
    case games
    case detail(gameId: String)
    case search(query: String)
}

extension GameService: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: "https://api.rawg.io/api/") else { fatalError() }
        return url
    }

    public var path: String {
        switch self {
        case .games:
            return "games"
        case .detail(let gameId):
            return "games/\(gameId)"
        case .search(query: _):
            return "games"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        var params: [String: Any] = [:]
        params["key"] = "4d2878b4a82a40e7a20744fc02ff66fe"
        switch self {
        case .search(let query):
            params["search"] = query
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return nil
    }
}
