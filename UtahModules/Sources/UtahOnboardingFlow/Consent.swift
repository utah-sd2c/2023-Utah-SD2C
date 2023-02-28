//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Onboarding
import SwiftUI


struct Consent: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    
    
    private var consentDocument: Data {
        guard let path = Bundle.module.url(forResource: "ConsentDocument", withExtension: "html"),
              let data = try? Data(contentsOf: path) else {
            return Data("CONSENT_LOADING_ERROR".moduleLocalized.utf8)
        }
        return data
    }

    var body: some View {
        ScrollViewReader { _ in
            OnboardingView(
                contentView: {
                    HTMLView(
                        asyncHTML: {
                            consentDocument
                        }
                    )
                },
                actionView: {
                    VStack {
                        OnboardingActionsView("I accept") {
                            onboardingSteps.append(.conditionQuestion)
                        }
                        Divider()
                    }
                    .transition(.opacity)
                }
            )
        }
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


struct Consent_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        Consent(onboardingSteps: $path)
    }
}
