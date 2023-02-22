//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FHIR
import HealthKitDataSource
import Onboarding
import SwiftUI
import UtahSharedContext


struct ConditionQuestion: View {
    @Binding var onboardingSteps: [OnboardingFlow.Step]
    @State private var selection = "Arterial Disease"
    let conditions = ["Arterial Disease", "Venous Disease"]
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "What condition do you have?".moduleLocalized,
                        subtitle: "".moduleLocalized
                    )
                    Picker("Select a condition", selection: $selection) {
                        ForEach(conditions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    Text("Selected: \(selection)")
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Next".moduleLocalized,
                    action: {
                        onboardingSteps.append(.healthKitPermissions)
                    }
                )
            }
        )
    }
}


struct ThingsToKnow_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        ConditionQuestion(onboardingSteps: $path)
    }
}
