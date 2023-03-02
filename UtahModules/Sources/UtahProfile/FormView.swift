//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct FormView: View {
    @Binding var disease: String
    @Binding var isEditing: Bool
    let diseaseOptions = ["Peripheral Arterial Disease", "Venous Insufficiency", "I'm not sure"]
    var body: some View {
        Form {
            Section(header: Text("Condition")) {
                Picker("Change your condition", selection: $disease) {
                    ForEach(diseaseOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .padding(.vertical, 10)
            }
            Button(action: {
                isEditing = false
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
