//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct MenuButton: View {
    @Binding var eventBool: Bool
    var buttonLabel: String
    var foregroundColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Button(action: {
            eventBool = true
        }) {
            if foregroundColor == .accentColor {
                Text(buttonLabel)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(10)
//                    .font(.system(size: 25))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 2)
                    )
            } else {
                Text(buttonLabel)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(10)
//                    .font(.system(size: 25))
            }
        }
        .padding(.bottom, 30)
    }
}
