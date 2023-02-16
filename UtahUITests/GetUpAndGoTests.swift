//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class GetUpAndGoTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testGetUpAndGo() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 0.5))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.buttons["Get Up And Go Question"].waitForExistence(timeout: 0.5))
        app.buttons["Get Up And Go Question"].tap()
        XCTAssertTrue(app.staticTexts["Do not do this alone. Please have someone by you to help you if necessary."].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.buttons["Start"].waitForExistence(timeout: 0.5))
    }
}
