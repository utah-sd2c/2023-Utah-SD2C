//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct Header: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundColor(Color.accentColor)
            .scaledToFit()
            .frame(width: 150, height: 150)
            .accessibility(label: Text("headshot"))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
