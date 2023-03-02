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
            Section(header: Text("REPORT A PROBLEM").font(.system(size: 20))) {
                Text("support@stanford.edu")
                    .font(.system(size: 24))
                    .padding(.vertical, 15)
            }
            Section(header: Text("SUPPORT").font(.system(size: 20))) {
                Link("+1 (801) 587-1450", destination: URL(string: "tel:(+1(801)587-1450)")!)
                    .font(.system(size: 24))
                    .padding(.vertical, 15)
            }
            Section(header: Text("WITHDRAW FROM STUDY").font(.system(size: 20))) {
                Link("+1 (801) 581-8301", destination: URL(string: "tel:(+1(801)-581-8301)")!)
                    .font(.system(size: 24))
                    .padding(.vertical, 15)
            }
        }
    }
}

struct HelpPageView_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
