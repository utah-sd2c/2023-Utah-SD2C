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
        
        XCTAssertTrue(app.staticTexts["Jiahui Chen"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Patient at University of Utah Hospital"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Email"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["jchen23@stanford.edu"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Phone"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["6504208566"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["Address"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["1047 Campus Drive, CA"].waitForExistence(timeout: 0.5))
    }
}
