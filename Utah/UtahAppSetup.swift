//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import SwiftUI
import UtahSharedContext


private struct UtahSetup: ViewModifier {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = true
    
    
    func body(content: Content) -> some View {
        content
            .task {
                if Auth.auth().currentUser == nil {
                    completedOnboardingFlow = false
                }
            }
    }
}


extension View {
    func setup() -> some View {
        self.modifier(UtahSetup())
    }
}
