//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class EdmontonTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    func testEdmonton() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.buttons["Edmonton Frail Scale"].waitForExistence(timeout: 2))
        app.buttons["Edmonton Frail Scale"].tap()
        XCTAssertTrue(app.staticTexts["Patient Questionnaire"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()
        XCTAssertTrue(app.staticTexts["Draw a clock"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 2))
        app.buttons["Get Started"].tap()
        
        XCTAssertTrue(app.buttons["Skip"].waitForExistence(timeout: 2))
        app.buttons["Skip"].tap()
        
        // Go through each question
        let answers = ["0", "Good", "5-8", "Sometimes", "Yes", "No", "Yes", "No", "No"]
        for answer in answers {
            XCTAssertTrue(app.tables.staticTexts[answer].waitForExistence(timeout: 2))
            app.tables.staticTexts[answer].tap()
            XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 2))
            app.tables.buttons["Next"].tap()
        }
    
        XCTAssertTrue(app.staticTexts["Get Up and Go"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()
        
        /* Need to update view controller to allow tests
        XCTAssertTrue(app.staticTexts["Stop"].waitForExistence(timeout: 1))
        app.staticTexts["Stop"].tap()
        
        XCTAssertTrue(app.staticTexts["11-20 Seconds"].waitForExistence(timeout: 1))
        app.staticTexts["11-20 Seconds"].tap()
        XCTAssertTrue(app.staticTexts["Thank you."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 2))
        app.buttons["Done"].tap()*/
    }
}
