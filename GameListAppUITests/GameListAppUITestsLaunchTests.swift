//
//  GameListAppUITestsLaunchTests.swift
//  GameListAppUITests
//
//  Created by Berkay Sancar on 16.08.2022.
//

import XCTest

class GameListAppUITestsLaunchTests: XCTestCase {
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
