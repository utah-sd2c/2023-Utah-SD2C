//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct InfoRow: View {
    var field: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(field)
//                .font(.system(size: 20))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.bottom, 5)
        
        HStack {
            Text(value)
//                .font(.system(size: 25))
            Spacer()
        }
        Divider()
            .padding(.bottom, 20)
    }
}
