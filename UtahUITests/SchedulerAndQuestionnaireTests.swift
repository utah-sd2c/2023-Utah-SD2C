//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


class SchedulerAndQuestionnaireTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "U-STEP")
    }
    
    
    func testSchedulerAndQuestionnaire() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()

        XCTAssertTrue(app.staticTexts["Questionnaire"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Please complete this task once a month."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Start Task"].waitForExistence(timeout: 2))
        app.staticTexts["Start Task"].tap()

        try app.navigateVenousQuestionnaire()
    }
}

extension XCUIApplication {
    func navigateVenousQuestionnaire() throws {
        try navigateEdmonton()
        try navigateVeines()
    }
    
    private func navigateEdmonton() throws {
        XCTAssertTrue(staticTexts["Patient Questionnaire"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        XCTAssertTrue(staticTexts["Draw a clock"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Get Started"].waitForExistence(timeout: 2))
        buttons["Get Started"].tap()
        
        XCTAssertTrue(buttons["Skip"].waitForExistence(timeout: 2))
        buttons["Skip"].tap()
        
        // Go through each question
        let answers = ["0", "Good", "5-8", "Sometimes", "Yes", "No", "Yes", "No", "No"]
        for answer in answers {
            XCTAssertTrue(tables.staticTexts[answer].waitForExistence(timeout: 2))
            tables.staticTexts[answer].tap()
            XCTAssertTrue(tables.buttons["Next"].waitForExistence(timeout: 2))
            tables.buttons["Next"].tap()
        }
    
        XCTAssertTrue(staticTexts["Get Up and Go"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        XCTAssertTrue(buttons["STOP"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["STOP"].waitForExistence(timeout: 2))
        buttons["STOP"].tap()
        
        XCTAssertTrue(buttons["11-20 Seconds"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["11-20 Seconds"].waitForExistence(timeout: 2))
        buttons["11-20 Seconds"].tap()
    }
    
    private func navigateVeines() throws {
        let numSubQuestions = [9, 1, 1, 4, 4, 1, 1, 5]
        
        for _ in numSubQuestions {
            XCTAssertTrue(tables.element(boundBy: 0).waitForExistence(timeout: 2))
            XCTAssertTrue(tables.element(boundBy: 0).cells.element(boundBy: 0).waitForExistence(timeout: 2))
            tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
            XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
            buttons["Next"].tap()
        }

        XCTAssertTrue(staticTexts["Thank you."].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Done"].waitForExistence(timeout: 2))
        buttons["Done"].tap()
    }
}
