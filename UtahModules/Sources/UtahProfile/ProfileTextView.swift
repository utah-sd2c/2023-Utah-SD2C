//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import SwiftUI
import class FHIR.FHIR
import FirebaseAccount
import FirebaseAuth
import FirebaseFirestore
import Onboarding

struct ProfileText: View {
    let user = Auth.auth().currentUser
    @AppStorage("subtitle") var subtitle = "Patient at University of Utah Hospital"
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text(user?.displayName ?? "")
                    .bold()
                    .font(.system(size: 30))
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
                .padding()
        }
    }
}
