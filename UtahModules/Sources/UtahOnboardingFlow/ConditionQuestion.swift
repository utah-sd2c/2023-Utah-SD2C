//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFirestore
import SpeziFHIR
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI
import UtahSharedContext


struct ConditionQuestion: View {
    @Binding var onboardingSteps: [OnboardingFlow.Step]
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var selection = "Choose Diagnosis"
    var conditions = StorageKeys.conditions + ["Choose Diagnosis"]
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "What is your diagnosis?".moduleLocalized,
                        subtitle: "Please consult your doctor if you are unsure.".moduleLocalized
                    )
                    Spacer()
                            Picker("Select your condition", selection: $selection) {
                                ForEach(conditions, id: \.self) { option in
                                    Text(option).disabled(option == "Choose Disease")
                                }
                            }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .shadow(color: .gray, radius: 2)
                                .padding(.horizontal, 15)
                        )
                    .pickerStyle(.menu)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Next".moduleLocalized,
                    action: {
                        // Store condition locally in UserDefaults
                        let defaults = UserDefaults.standard
                        defaults.set(selection, forKey: "disease")

                        // Store condition in Firestore
                        if let user = Auth.auth().currentUser {
                            Firestore.firestore().collection("users").document(user.uid).updateData(["disease": selection]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    firestoreManager.fetchAll()
                                    onboardingSteps.append(.healthKitPermissions)
                                }
                            }
                       }
                    }
                ).disabled(selection == "Choose Diagnosis")
            }
        )
    }
}


struct Condition_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        ConditionQuestion(onboardingSteps: $path)
    }
}
