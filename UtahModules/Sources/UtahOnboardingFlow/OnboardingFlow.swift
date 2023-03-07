//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UtahSharedContext


/// Displays an multi-step onboarding flow for the CS342 2023 Utah Team Application.
public struct OnboardingFlow: View {
    public enum Step: String, Codable {
        case accountSetup
        case login
        case signUp
        case consent
        case conditionQuestion
        case healthKitPermissions
        case taskScheduling
    }
    
    
    @SceneStorage(StorageKeys.onboardingFlowStep) private var onboardingSteps: [Step] = []
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    
    public var body: some View {
        NavigationStack(path: $onboardingSteps) {
            Welcome(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .accountSetup:
                        AccountSetup(onboardingSteps: $onboardingSteps)
                    case .login:
                        UtahLogin()
                    case .signUp:
                        UtahSignUp()
                    case .consent:
                        Consent(onboardingSteps: $onboardingSteps)
                    case .conditionQuestion:
                        ConditionQuestion(onboardingSteps: $onboardingSteps)
                    case .healthKitPermissions:
                        HealthKitPermissions(onboardingSteps: $onboardingSteps)
                    case .taskScheduling:
                        TaskScheduling()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
    }
    
    
    public init() {}
}


struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow()
    }
}
