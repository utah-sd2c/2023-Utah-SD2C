//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import UtahSharedContext

struct FormView: View {
    @Binding var disease: String
    @Binding var isEditing: Bool
    var body: some View {
        Form {
            Section(header: Text("Condition")) {
                Picker("Change your condition", selection: $disease) {
                    ForEach(StorageKeys.conditions, id: \.self) { option in
                        Text(option)
                    }
                }
                .padding(.vertical, 10)
            }
            Button(action: {
                isEditing = false
                if let user = Auth.auth().currentUser {
                    Firestore.firestore().collection("users").document(user.uid).updateData(["disease": disease]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                    }
               }
            }) {
                HStack {
                    Spacer()
                    Text("Save")
                    Spacer()
                }
            }
        }
        .navigationTitle(Text("Setting"))
    }
}
