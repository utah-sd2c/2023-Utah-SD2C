//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct InfoRowView: View {
    var title: String
    var value: String
    var image: String
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .foregroundColor(.primary)
                .font(.headline)
            HStack(spacing: 3) {
                Label(value, systemImage: image)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
}
