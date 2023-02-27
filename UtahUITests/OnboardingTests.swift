//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTHealthKit


import XCTestExtensions


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try disablePasswordAutofill()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "Utah")
    }
    
    
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        try app.navigateOnboardingFlow(assertThatHealthKitConsentIsShown: true)
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Questions"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(tabBar.buttons["Trends"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(tabBar.buttons["Profile"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(tabBar.buttons["Mock Upload"].waitForExistence(timeout: 0.5))
    }
}


extension XCUIApplication {
    func conductOnboardingIfNeeded() throws {
        if self.staticTexts["Welcome to U-STEP"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlow(assertThatHealthKitConsentIsShown: false)
        }
    }
    
    func navigateOnboardingFlow(assertThatHealthKitConsentIsShown: Bool = true) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingAccount()
        if staticTexts["Consent"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlowConsent()
        }
        try navigateOnboardingConditionQuestion()
        try navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: assertThatHealthKitConsentIsShown)
    }
    
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 0.5))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingAccount() throws {
        XCTAssertTrue(staticTexts["Your Account"].waitForExistence(timeout: 2))
        
        guard !buttons["Next"].waitForExistence(timeout: 5) else {
            buttons["Next"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Sign Up"].waitForExistence(timeout: 2))
        buttons["Sign Up"].tap()
        
        XCTAssertTrue(navigationBars.staticTexts["Sign Up"].waitForExistence(timeout: 2))
        XCTAssertTrue(images["App Icon"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Email and Password"].waitForExistence(timeout: 2))
        
        buttons["Email and Password"].tap()
        
        try textFields["Enter your email ..."].enter(value: "leland@stanford.edu")
        swipeUp()
        
        secureTextFields["Enter your password ..."].tap()
        secureTextFields["Enter your password ..."].typeText("StanfordRocks")
        swipeUp()
        secureTextFields["Repeat your password ..."].tap()
        secureTextFields["Repeat your password ..."].typeText("StanfordRocks")
        swipeUp()
        
        try textFields["Enter your given name ..."].enter(value: "Leland")
        staticTexts["Repeat\nPassword"].swipeUp()
        
        try textFields["Enter your family name ..."].enter(value: "Stanford")
        staticTexts["Repeat\nPassword"].swipeUp()
        
        collectionViews.buttons["Sign Up"].tap()
        
        sleep(3)
    }
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent"].waitForExistence(timeout: 0.5))
        
        
        XCTAssertTrue(staticTexts["Given Name"].waitForExistence(timeout: 2))
        try textFields["Enter your given name ..."].enter(value: "Leland")
        textFields["Enter your given name ..."].typeText("\n")
        
        XCTAssertTrue(staticTexts["Family Name"].waitForExistence(timeout: 2))
        try textFields["Enter your family name ..."].enter(value: "Stanford")
        textFields["Enter your family name ..."].typeText("\n")
        
        XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
        staticTexts["Leland Stanford"].firstMatch.swipeUp()
        
        XCTAssertTrue(buttons["I Consent"].waitForExistence(timeout: 2))
        buttons["I Consent"].tap()
    }
    
    private func navigateOnboardingConditionQuestion() throws {
        XCTAssertTrue(staticTexts["What condition do you have?"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 0.5))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: Bool = true) throws {
        XCTAssertTrue(images["heart.text.square.fill"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(buttons["Grant Access"].waitForExistence(timeout: 0.5))
        buttons["Grant Access"].tap()
        
        if self.navigationBars["Health Access"].waitForExistence(timeout: 30) {
            self.tables.staticTexts["Turn On All"].tap()
            self.navigationBars["Health Access"].buttons["Allow"].tap()
        } else if assertThatHealthKitConsentIsShown {
            XCTFail("Did not display the Health Consent Screen")
        }
    }
}
