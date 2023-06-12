//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try disablePasswordAutofill()
        
        continueAfterFailure = true
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "U-STEP")
    }
    
    
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        try app.navigateOnboardingFlow(assertThatHealthKitConsentIsShown: true)
        addUIInterruptionMonitor(withDescription: "System Dialog") {alert -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        app.tap()
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Questions"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Trends"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Profile"].waitForExistence(timeout: 2))
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
        if staticTexts["What is your diagnosis?"].waitForExistence(timeout: 5) {
            try navigateOnboardingConditionQuestion()
        }
        try navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: assertThatHealthKitConsentIsShown)
        try navigateScheduling()
    }
    
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingAccount() throws {
        XCTAssertTrue(staticTexts["Welcome to U-STEP"].waitForExistence(timeout: 2))
        
        guard !buttons["Continue"].waitForExistence(timeout: 5) else {
            buttons["Continue"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Sign Up"].waitForExistence(timeout: 2))
        buttons["Sign Up"].tap()
        
        try navigateOnboardingFlowConsent()
        
        XCTAssertTrue(navigationBars.staticTexts["Sign Up"].waitForExistence(timeout: 4))
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
        
        try textFields["Enter your first name ..."].enter(value: "Leland")
        staticTexts["Repeat\nPassword"].swipeUp()
        
        try textFields["Enter your last name ..."].enter(value: "Stanford")
        staticTexts["Repeat\nPassword"].swipeUp()
        
        collectionViews.buttons["Sign Up"].tap()
        
        sleep(3)
        
        try navigateOnboardingConditionQuestion()
    }
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent Form"].waitForExistence(timeout: 10))
        
        swipeUp(velocity: .fast)
        swipeUp(velocity: .fast)
        swipeUp(velocity: .fast)
        swipeUp(velocity: .fast)
        swipeUp(velocity: .fast)
        swipeUp(velocity: .fast)
        
        XCTAssertTrue(buttons["I accept"].waitForExistence(timeout: 2))
        buttons["I accept"].tap()
    }
    
    private func navigateOnboardingConditionQuestion() throws {
        XCTAssertTrue(staticTexts["What is your diagnosis?"].waitForExistence(timeout: 2))
        XCTAssertTrue(staticTexts["Choose Diagnosis"].waitForExistence(timeout: 2))
        staticTexts["Choose Diagnosis"].tap()
        XCTAssertTrue(buttons["Arterial Disease"].waitForExistence(timeout: 2))
        buttons["Arterial Disease"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: Bool = true) throws {
        XCTAssertTrue(images["heart.text.square.fill"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Grant Access"].waitForExistence(timeout: 2))
        buttons["Grant Access"].tap()
        
        try handleHealthKitAuthorization()
    }
    
    private func navigateScheduling() throws {
        XCTAssertTrue(images["heart.text.square.fill"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Continue"].waitForExistence(timeout: 2))
        buttons["Continue"].tap()
    }
}
