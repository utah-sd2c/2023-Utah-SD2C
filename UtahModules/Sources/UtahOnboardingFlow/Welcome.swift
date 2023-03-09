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
        utahLogo
            .resizable()
            .scaledToFill()
            .accessibilityLabel(Text("University of Utah logo"))
            .frame(width: 166, height: 44)
            .padding(.top, 40)
        OnboardingView(
            title: "Welcome to U-STEP".moduleLocalized,
            subtitle: "A collaboration between University of Utah & Stanford University".moduleLocalized,
            areas: [
                .init(
                    icon: Image(systemName: "list.clipboard"),
                    title: "Report your health outcomes".moduleLocalized,
                    description: "Fill out surveys about your health".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "figure.walk"),
                    title: "Track your health".moduleLocalized,
                    description: "Record your daily activity levels".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "chart.line.uptrend.xyaxis"),
                    title: "Monitor your progress".moduleLocalized,
                    description: "View your progression over time\n".moduleLocalized
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
        ).padding(.top, -20)
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
