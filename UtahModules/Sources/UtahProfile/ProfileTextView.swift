//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import FirebaseAuth
import SpeziFirebaseAccount
import SwiftUI

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
