//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import SwiftUI
import UtahOnboardingFlow
import UtahSharedContext


@main
struct Utah: App {
    @UIApplicationDelegateAdaptor(UtahAppDelegate.self) var appDelegate
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = true
    
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .sheet(isPresented: !$completedOnboardingFlow) {
                    OnboardingFlow()
                }
                .setup()
                .testingSetup()
                .cardinalKit(appDelegate)
        }
    }
}
