//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI

public struct Trends: View {
    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                DataCard(icon: "shoeprints.fill", title: "Daily Step Count", unit: "steps", color: Color.green)
                DataCard(icon: "list.clipboard.fill", title: "Survey Score", unit: "points", color: Color.blue)
            }
            .padding()
            Spacer()
            .navigationTitle("Trends")
        }
    }
    
    
    public init() {}
}

// This just removes this section from being counted in our % "test coverage"
#if !TESTING

struct Trends_Previews: PreviewProvider {
    static var previews: some View {
        Trends()
    }
}

#endif
