//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class WIQTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    func testWIQ() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 0.5))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.buttons["Walking Impairement Questionnaire"].waitForExistence(timeout: 0.5))
        app.buttons["Walking Impairement Questionnaire"].tap()
        XCTAssertTrue(app.staticTexts["Walking Impairement Questionnaire"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Patient Mobility Assessment"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 0.5))
        app.buttons["Get Started"].tap()
        
        // Go through each question
        let answers = [
            "No Difficulty",
            "Slight Difficulty",
            "Some Difficulty",
            "Much Difficulty",
            "Unable to Do",
            "Slight Difficulty",
            "No Difficulty"
        ]
        for answer in answers {
            XCTAssertTrue(app.tables.staticTexts[answer].waitForExistence(timeout: 0.5))
            app.tables.staticTexts[answer].tap()
            XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 0.5))
            app.tables.buttons["Next"].tap()
        }
        
        XCTAssertTrue(app.staticTexts["Thank you."].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 0.5))
        app.buttons["Done"].tap()
    }
}
