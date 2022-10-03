//
//  GameListEndpoints.swift
//  GameListApp
//
//  Created by Berkay Sancar on 3.10.2022.
//

import Foundation

enum GameListEndpoints: ServiceEndpointProtocols {
    
    case getList
    case getDetail
    
    var baseURLString: String {
        switch self {
        case .getList:
            return "https://api.rawg.io/api"
        case .getDetail:
            return "https://api.rawg.io/api"
        }
    }
    
    var path: String {
        switch self {
        case .getList:
            return "/games?"
        case .getDetail:
            return "/games/"
        }
    }
    
    var apiKey: String {
        switch self {
        case .getList:
            return "key=7a692c0b214f47b0bb664039491b1fcf"
        case .getDetail:
            return "key=7a692c0b214f47b0bb664039491b1fcf"
        }
    }
}
