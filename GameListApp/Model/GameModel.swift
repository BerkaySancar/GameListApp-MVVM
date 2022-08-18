//
//  GameModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Foundation

struct BaseResponse: Codable {
    
    let results: [Game]
}

struct Game: Codable {
    
    let id: Int?
    let name: String?
    let released: String?
    let background_image: String?
}
