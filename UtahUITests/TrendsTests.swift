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
        
        try disablePasswordAutofill()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "U-STEP")
    }
    
    
    func testTrends() throws {
        let app = XCUIApplication()
        try app.conductOnboardingIfNeeded()
        try navigateToTrends()
        let prevValue = Double(app.staticTexts["steps_val"].label)
        try exitAppAndOpenHealth(.steps)
        app.activate()
        sleep(5)
        let newVal = (prevValue ?? 0.0) + 42
        // Need to navigate to another tab first to refresh number
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Questions"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Questions"].tap()
        try navigateToTrends()
        // XCTAssert(app.staticTexts[String(newVal)].waitForExistence(timeout: 2))
    }
    
    func navigateToTrends() throws {
        let app = XCUIApplication()
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Trends"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Trends"].tap()
        XCTAssertTrue(app.staticTexts["Daily Step Count"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Last EFS Survey Score"].waitForExistence(timeout: 2))
    }
}
