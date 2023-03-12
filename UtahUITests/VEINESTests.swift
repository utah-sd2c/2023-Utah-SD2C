//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class VEINESTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    /*func testWIQ() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.buttons["VEINES-QOL/Sym Questionnaire"].waitForExistence(timeout: 2))
        app.buttons["VEINES-QOL/Sym Questionnaire"].tap()
        XCTAssertTrue(app.staticTexts["VEINES-QOL/Sym Questionnaire"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 2))
        app.buttons["Get Started"].tap()
        
//        // Go through each question
//        // question 1
//        let answers = [
//            ["Every day", "Several times a week", "About once a week", "Less than once a week", "Never", "Less than once a week", "About once a week", "Several times a week", "Every day"],
//            ["During the night"],
//            ["Somewhat better now than one year ago"]
//        ]
//        for answer in answers {
//            for option in answer {
//                XCTAssertTrue(app.tables.staticTexts[option].waitForExistence(timeout: 2))
//                app.tables.staticTexts[option].tap()
//            }
//            XCTAssertTrue(app.tables.buttons["Next"].waitForExistence(timeout: 2))
//            app.tables.buttons["Next"].tap()
//        }
//
//        XCTAssertTrue(app.staticTexts["Thank you."].waitForExistence(timeout: 2))
//        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 2))
//        app.buttons["Done"].tap()
    }*/
}
