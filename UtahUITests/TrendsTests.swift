//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class TrendsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testTrends() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Trends"].waitForExistence(timeout: 0.5))
        app.tabBars["Tab Bar"].buttons["Trends"].tap()
        
        XCTAssertTrue(app.staticTexts["Welcome to your trends page!"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Show previous survey responses"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Show activity history"].waitForExistence(timeout: 0.5))
    }
}
