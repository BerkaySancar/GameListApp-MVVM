//
//  GameListAppTests.swift
//  GameListAppTests
//
//  Created by Berkay Sancar on 16.08.2022.
//

import XCTest
@testable import GameListApp

class GameListAppTests: XCTestCase {

    func testSuccessParser() {
            
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
}
