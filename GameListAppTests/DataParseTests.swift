//
//  GameListAppTests.swift
//  GameListAppTests
//
//  Created by Berkay Sancar on 16.08.2022.
//

@testable import GameListApp
import XCTest

class DataParseTests: XCTestCase {

    func testSuccessGameParser() {
            
        let json = """
                    {
                    "results": [
                    {
                        "id": 3498,
                        "name": "name",
                        "released": "released",
                        "background_image": "background_image"
                    }
                    ]
                    }
                    """.data(using: .utf8)!
            
            let games = try! JSONDecoder().decode(Game.self, from: json)

            XCTAssertNotNil(games)
        }
    
    func testSuccessDetailParser() {
        
        let json = """
                    {
                    "id": 3498,
                    "name": "name",
                    "description": "description",
                    "background_image": "background",
                    "website": "website"
                    }
                    """.data(using: .utf8)!
        
        let details = try! JSONDecoder().decode(Detail.self, from: json)
        
        XCTAssertNotNil(details)
    }
}
