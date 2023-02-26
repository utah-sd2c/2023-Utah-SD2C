//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FHIR
import FirebaseAuth
import FirebaseFirestore
import HealthKitDataSource
import Onboarding
import SwiftUI
import UtahSharedContext


struct ConditionQuestion: View {
    @Binding var onboardingSteps: [OnboardingFlow.Step]
    @State private var selection = "I Don't Know"
    let conditions = ["Arterial Disease", "Venous Disease", "I Don't Know"]
    
    
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
                            Text($0).scaleEffect(2)
                        }
                    }
                    .pickerStyle(.menu)
                    .scaleEffect(2)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Next".moduleLocalized,
                    action: {
                        if let user = Auth.auth().currentUser {
                            Firestore.firestore().collection("users").document(user.uid).updateData(["disease": selection]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    onboardingSteps.append(.healthKitPermissions)
                                }
                            }
                       }
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
