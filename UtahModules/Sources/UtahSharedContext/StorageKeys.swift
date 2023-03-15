//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// Constants shared across the CardinalKit Teamplate Application to access storage information including the `AppStorage` and `SceneStorage`
public enum StorageKeys {
    // MARK: - Onboarding
    /// A `Bool` flag indicating of the onboarding was completed.
    public static let onboardingFlowComplete = "onboardingFlow.complete"
    /// A `Step` flag indicating the current step in the onboarding process.
    public static let onboardingFlowStep = "onboardingFlow.step"
    
    
    // MARK: - Home
    /// The currently selected home tab.
    public static let homeTabSelection = "home.tabselection"
    
    // MARK: - Condition
    /// The conditions the patients can choose from
    public static var conditions = ["Arterial Disease", "Venous Disease", "I Don't Know"]
    
    // MARK: - Survey Results
    /// The results of edmonton survey that patient will see
    public static var surveyResult = [
        "Healthy": "You are doing well and do not have many health concerns.",
        "Vulnerable": "You have some health concerns and may benefit from extra support and care.",
        "Frail": "You have significant health concerns and may need help with daily tasks and activities."
    ]
}
