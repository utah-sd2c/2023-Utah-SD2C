//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable line_length
import Account
import class FHIR.FHIR
import FirebaseAccount
import FirebaseAuth
import FirebaseFirestore
import Onboarding
import SwiftUI


struct AccountSetup: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @EnvironmentObject var account: Account
    @State var isSigningUp: Bool
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "ACCOUNT_TITLE".moduleLocalized,
                        subtitle: "ACCOUNT_SUBTITLE".moduleLocalized
                    )
                    Spacer(minLength: 0)
                    accountImage
                    accountDescription
                    Spacer(minLength: 0)
                }
            }, actionView: {
                actionView
            }
        )
            .onReceive(account.objectWillChange) {
                if account.signedIn {
                    if onboardingSteps.contains(where: { $0 == .signUp }) {
                         if let user = Auth.auth().currentUser {
                             let fullName = user.displayName?.components(separatedBy: " ")
                             let firstName = fullName?[0] ?? ""
                             let lastName = fullName?[1] ?? ""
                             let data: [String: Any] = ["firstName": firstName, "lastName": lastName, "email": user.email ?? "", "dateJoined": Timestamp()]
                            Firestore.firestore().collection("users").document(user.uid).setData(data)
                        }
                    }
                    appendNextOnboardingStep()
                    // Unfortunately, SwiftUI currently animates changes in the navigation path that do not change
                    // the current top view. Therefore we need to do the following async procedure to remove the
                    // `.login` and `.signUp` steps while disabling the animations before and re-enabling them
                    // after the elements have been changed.
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(1.0))
                        UIView.setAnimationsEnabled(false)
                        onboardingSteps.removeAll(where: { $0 == .login || $0 == .signUp })
                        try? await Task.sleep(for: .seconds(1.0))
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
    }
    
    @ViewBuilder
    private var accountImage: some View {
        Group {
            if account.signedIn {
                Image(systemName: "person.badge.shield.checkmark.fill")
            } else {
                Image(systemName: "person.fill.badge.plus")
            }
        }
            .font(.system(size: 150))
            .foregroundColor(.accentColor)
    }
    
    @ViewBuilder
    private var accountDescription: some View {
        VStack {
            Group {
                if account.signedIn {
                    Text("ACCOUNT_SIGNED_IN_DESCRIPTION", bundle: .module)
                } else {
                    Text("ACCOUNT_SETUP_DESCRIPTION", bundle: .module)
                }
            }
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
            if account.signedIn {
                UserView()
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private var actionView: some View {
        if account.signedIn {
            OnboardingActionsView(
                "ACCOUNT_NEXT".moduleLocalized,
                action: {
                    appendNextOnboardingStep()
                }
            )
        } else {
            OnboardingActionsView(
                primaryText: "ACCOUNT_SIGN_UP".moduleLocalized,
                primaryAction: {
                    isSigningUp = true
                    onboardingSteps.append(.signUp)
                },
                secondaryText: "ACCOUNT_LOGIN".moduleLocalized,
                secondaryAction: {
                    isSigningUp = false
                    onboardingSteps.append(.login)
                }
            )
        }
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
        self.isSigningUp = false
    }
    
    private func appendNextOnboardingStep() {
        if isSigningUp {
            #if targetEnvironment(simulator) && (arch(i386) || arch(x86_64))
            print("PKCanvas view-related views are currently skipped on Intel-based iOS simulators due to a metal bug on the simulator.")
            onboardingSteps.append(.conditionQuestion)
            #else
            onboardingSteps.append(.consent)
            #endif
        } else {
            onboardingSteps.append(.healthKitPermissions)
        }
    }
}


#if DEBUG
struct AccountSetup_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        AccountSetup(onboardingSteps: $path)
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
