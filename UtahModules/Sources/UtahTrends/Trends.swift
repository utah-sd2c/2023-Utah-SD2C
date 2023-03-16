//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable identifier_name
// swiftlint:disable closure_body_length
// swiftlint:disable large_tuple


import Account
import SwiftUI
import class FHIR.FHIR
import FirebaseAuth
import FirebaseFirestore
import UtahSharedContext


public struct Trends: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var showStepCount = false
    @State private var showEdmonton = false
    // we will check whether we have these surveys in the db
    @State private var edmonton_db = false
    @State private var veins_db = false
    @State private var wiq_db = false
    
    public var body: some View {
        NavigationStack {
            VStack {
                ForEach(getKeys(dict: firestoreManager.surveys), id: \.self) { survey in
                    if survey == "edmonton"{
                        DataCard(
                            icon: "figure.run",
                            title: "Latest EFS Score",
                            unit: "points",
                            color: Color.blue
                        )
                        .padding(.vertical, 10)
                        .onTapGesture {
                            self.showEdmonton.toggle()
                        }
                        .sheet(isPresented: $showEdmonton) {
                            EdmontonChart()
                        }
                    } else if survey == "veines" {
                        DataCard(icon: "list.clipboard.fill", title: "Veines Survey Score", unit: "points", color: Color.purple)
                            .padding(.vertical, 10)
                    }
                }
                DataCard(
                    icon: "shoeprints.fill",
                    title: "Average Step Count",
                    unit: "steps",
                    color: Color.green
                )
                .padding(.vertical, 10)
                .onTapGesture {
                    self.showStepCount.toggle()
                }
                .sheet(isPresented: $showStepCount) {
                    StepCountChart()
                }
                Spacer()
            }
            // temporary fix
            .navigationBarTitle("Trends")
        }
    }

    
    public init() {
    }
}

func getKeys(dict: [String: [(dateCompleted: Date, score: Int, surveyId: String)]]) -> [String] {
    let sortedDict = dict.sorted(by: { $0.0 < $1.0 })
    let keys = sortedDict.map { $0.0 }
    return keys
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
