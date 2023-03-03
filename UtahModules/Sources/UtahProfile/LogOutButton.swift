//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import FirebaseAuth
import SwiftUI
import UtahOnboardingFlow
import UtahSharedContext

struct LogoutButton: View {
    @Binding var eventBool: Bool
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = true
    @SceneStorage(StorageKeys.onboardingFlowStep) private var onboardingSteps: [OnboardingFlow.Step] = []
    @EnvironmentObject var account: Account
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var buttonLabel: String
    var foregroundColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                firestoreManager.update()
                onboardingSteps = []
                eventBool = true
                account.signedIn = false
                completedOnboardingFlow = false
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }) {
            Text(buttonLabel)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(10)
                .font(.system(size: 25))
        }
        .padding(.bottom, 30)
    }
}
