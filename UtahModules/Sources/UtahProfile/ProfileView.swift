//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct Profile: View {
    @State var disease = "Peripheral Arterial Disease"
    public var body: some View {
        VStack {
            EditButton(disease: $disease)
                .padding(.trailing, 35)
            Header()
            ProfileText()
                .padding(.bottom, 30)
            UserInformationView(disease: $disease)
        }
        .padding(.top, 30)
    }
    public init() {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
