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
        
        // Go through each question
        let answers = ["0", "Good", "5-8", "Sometimes", "Yes", "No", "Yes", "No"]
        for answer in answers {
            XCTAssertTrue(app.tables.staticTexts[answer].waitForExistence(timeout: 0.5))
            app.tables.staticTexts[answer].tap()
            XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 0.5))
            app.tables.buttons["Next"].tap()
        }
         // Last Question
        XCTAssertTrue(app.staticTexts["Do you have a problem with losing control of urine when you don’t want to?"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.tables.staticTexts["No"].waitForExistence(timeout: 0.5))
        app.tables.staticTexts["No"].tap()
        XCTAssertTrue(app.tables.buttons["Done"].waitForExistence(timeout: 0.5))
        app.tables.buttons["Done"].tap()
        
        XCTAssertTrue(!app.staticTexts["Start Questionnaire"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.images["Selected"].waitForExistence(timeout: 0.5))
    }
}
