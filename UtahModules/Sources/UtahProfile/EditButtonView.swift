//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct EditButton: View {
    @State private var isEditing = false
    @Binding var disease: String
    
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
                    FormView(disease: $disease, isEditing: $isEditing)
                }
        }
    }
}
