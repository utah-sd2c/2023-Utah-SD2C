//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UtahSharedContext

struct EditButton: View {
    @State private var isEditing = false
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                isEditing = true
            }, label: {
                Text("Edit")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            })
                .sheet(isPresented: $isEditing) {
                    FormView(disease: $firestoreManager.disease, isEditing: $isEditing)
                }
        }
    }
}
