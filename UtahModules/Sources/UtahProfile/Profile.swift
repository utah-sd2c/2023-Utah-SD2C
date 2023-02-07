//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public struct Profile: View {
    public var body: some View {
        VStack {
            Text("Welcome to your profile page!")
            Text("Firstname Lastname")
            Text("Condition Name")
        }
    }
    
    
    public init() {}
}

// This just removes this section from being counted in our % "test coverage"
#if !TESTING

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

#endif
