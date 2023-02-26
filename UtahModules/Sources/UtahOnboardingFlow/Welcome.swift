//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Onboarding
import SwiftUI
import UtahSharedContext


struct Welcome: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    
    
    var body: some View {
        OnboardingView(
            title: "Welcome to VascuTrack".moduleLocalized,
            subtitle: "A collaboration between Stanford University & University of Utah".moduleLocalized,
            areas: [
                .init(
                    icon: Image(systemName: "apps.iphone"),
                    title: "Track your health".moduleLocalized,
                    description: "Easily see your biometric data".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "shippingbox.fill"),
                    title: "Report your outcomes".moduleLocalized,
                    description: "Fill out surveys about your health".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "list.bullet.clipboard.fill"),
                    title: "Streamline your care".moduleLocalized,
                    description: "Help your doctors help you get better".moduleLocalized
                )
            ],
            actionText: "Next".moduleLocalized,
            action: {
                if !FeatureFlags.disableFirebase {
                    onboardingSteps.append(.accountSetup)
                } else {
                    onboardingSteps.append(.consent)
                }
            }
        )
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


struct Welcome_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        Welcome(onboardingSteps: $path)
    }
}
