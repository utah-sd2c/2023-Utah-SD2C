//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct Profile: View {
    @State var isPresented = false

    public var body: some View {
        VStack {
            Header()
            ProfileText()
            UserInformationView()
        }
    }
    public init() {}
}

struct ProfileText: View {
    @AppStorage("name") var name = "Jiahui Chen"
    @AppStorage("subtitle") var subtitle = "Patient at University of Utah Hospital"
    @AppStorage("description") var description = ""

    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text(name)
                    .bold()
                    .font(.title)
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
            }.padding()
            Text(description)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
#endif
