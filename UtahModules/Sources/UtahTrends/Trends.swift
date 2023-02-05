//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct Trends: View {
    public var body: some View {
        VStack {
            Text("Welcome to your trends page!")
            Text("Show previous survey responses")
            Text("Show activity history")
        }
    }
    
    
    public init() {}
}

#if !TESTING

struct Trends_Previews: PreviewProvider {
    static var previews: some View {
        Trends()
    }
}

#endif
