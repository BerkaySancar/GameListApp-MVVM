//
//  GameListAppUITests.swift
//  GameListAppUITests
//
//  Created by Berkay Sancar on 16.08.2022.
//

import XCTest

class GameListAppUITests: XCTestCase {

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
