//
//  GameDetailModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 24.08.2022.
//

import Foundation

struct Detail: Codable {
    
    let name: String?
    let description: String?
    let backgroundImage: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, website
        case backgroundImage = "background_image"
    }
}
