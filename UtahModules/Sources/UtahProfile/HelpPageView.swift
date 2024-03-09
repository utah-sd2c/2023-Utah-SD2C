//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable force_unwrapping

import SwiftUI

struct HelpPage: View {
    var body: some View {
        Form {
            Section(header: Text("REPORT A PROBLEM")) {
                Link("UofUVascularSurgery@gmail.com", destination: URL(string:"mailto:UofUVascularSurgery@gmail.com")!)
                    .padding(.vertical, 10)
            }
            Section(header: Text("SUPPORT")) {
                Link("+1 (801) 587-1450", destination: URL(string: "tel:18015871450")!)
                    .padding(.vertical, 10)
            }
            Section(header: Text("WITHDRAW FROM STUDY")) {
                Link("+1 (801) 587-1450", destination: URL(string: "tel:18015871450")!)
                    .padding(.vertical, 10)
            }
        }
    }
}

struct HelpPageView_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
