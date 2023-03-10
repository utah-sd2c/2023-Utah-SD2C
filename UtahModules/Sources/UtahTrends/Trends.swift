//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import SwiftUI
import class FHIR.FHIR
import FirebaseAuth
import FirebaseFirestore
import UtahSharedContext


 public struct Trends: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
     
    public var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 10) {
                Charts()
                    .frame(minHeight: 250)
                Spacer()
                DataCard(
                    icon: "shoeprints.fill",
                    title: "Daily Step Count", unit: "steps",
                    color: Color.green
                )
                Spacer()
                // removed survey for now until we pull survey data from firestore
                // DataCard(icon: "list.clipboard.fill", title: "Last EFS Survey Score", unit: "points", color: Color.blue, observations: [])
                Spacer()
                StyledGauge(userScore: 50.0, minScore: 50.0, maxScore: 170.0)
                    .padding()
                    .frame(minWidth: 150)
            }
        }
        .padding()
        .navigationTitle("Trends")
    }
    public init() {
    }
}

// This just removes this section from being counted in our % "test coverage"
#if !TESTING

struct Trends_Previews: PreviewProvider {
    static var previews: some View {
        Trends()
            .environmentObject(FHIR())
    }
}

#endif
