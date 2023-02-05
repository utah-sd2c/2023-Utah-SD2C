//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class ProfileTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testProfile() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Profile"].waitForExistence(timeout: 0.5))
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        
        XCTAssertTrue(app.staticTexts["Welcome to your profile page!"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Firstname Lastname"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Condition Name"].waitForExistence(timeout: 0.5))
    }
}
