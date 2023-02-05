//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class SchedulerAndQuestionnaireTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "Utah")
    }
    
    
    func testSchedulerAndQuestionnaire() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 0.5))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.staticTexts["Monthly Questionnaire"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Please fill out this Questionnaire every month."].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Start Questionnaire"].waitForExistence(timeout: 0.5))
        
        app.staticTexts["Start Questionnaire"].tap()
        
        // Custom question I changed
        XCTAssertTrue(app.tables.staticTexts["0"].waitForExistence(timeout: 0.5))
        app.tables.staticTexts["0"].tap()
        XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 0.5))
        app.tables.buttons["Next"].tap()
        
        for _ in 0..<3 {
            XCTAssertTrue(app.tables.staticTexts["None of the time"].waitForExistence(timeout: 0.5))
            app.tables.staticTexts["None of the time"].tap()
            XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 0.5))
            app.tables.buttons["Next"].tap()
        }
                        
        XCTAssertTrue(app.textFields["Tap to answer"].waitForExistence(timeout: 0.5))
        app.textFields["Tap to answer"].tap()
        app.textFields["Tap to answer"].typeText("42")
        app.toolbars["Toolbar"].buttons["Done"].tap()
                        
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 0.5))
        app.buttons["Next"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["Phone call"].waitForExistence(timeout: 0.5))
        app.tables.staticTexts["Phone call"].tap()
        XCTAssertTrue(app.tables.buttons["Done"].waitForExistence(timeout: 0.5))
        app.tables.buttons["Done"].tap()
        
        XCTAssertTrue(!app.staticTexts["Start Questionnaire"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.images["Selected"].waitForExistence(timeout: 0.5))
    }
}
