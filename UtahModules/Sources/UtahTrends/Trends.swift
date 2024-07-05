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


import SpeziAccount
import SwiftUI
import class SpeziFHIR.FHIR
import FirebaseAuth
import FirebaseFirestore
import UtahSharedContext


public struct Trends: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var showStepCount = false
    @State private var showsixminutewalktestContentView = false
    @State private var showWalkTestChart = false
    @State private var showEdmonton = false
    @State private var showVeines = false
    @State private var showWIQ = false
    // we will check whether we have these surveys in the db
    @State private var edmonton_db = false
    @State private var veins_db = false
    @State private var wiq_db = false
    @State private var showDistanceTraveled = false
    @State private var averageDistance: Double = 0.0
    
    
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Trends")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    VStack  {
                            Text("Activity")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                        }
                        DataCard(
                            icon: "figure.walk",
                            title: "Average Distance Traveled",
                            unit: "mi",
                            color: Color.orange
                            
                        )
                        .padding(.vertical, 10)
                        .onTapGesture {
                            self.showDistanceTraveled.toggle()
                        }
                        .sheet(isPresented: $showDistanceTraveled) {
                            DistanceTraveledChart()
                                .environmentObject(healthKitManager)
                        }
                            Text("Questionnaires")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                                        SurveyChart(title: "Edmonton Frail Scale", surveyType: "edmonton")
                                    }
                                } else if survey == "veines" {
                                    DataCard(icon: "list.clipboard.fill", title: "Veines Survey Score", unit: "points", color: Color.purple)
                                        .padding(.vertical, 10)
                                        .onTapGesture {
                                            self.showVeines.toggle()
                                        }
                                        .sheet(isPresented: $showVeines) {
                                            SurveyChart(title: "Veines Survey", surveyType: "veines")
                                        }
                                } else if survey == "wiq" {
                                    DataCard(icon: "figure.walk", title: "WIQ Survey Score", unit: "points", color: Color.red)
                                        .padding(.vertical, 10)
                                        .onTapGesture {
                                            self.showWIQ.toggle()
                                        }
                                        .sheet(isPresented: $showWIQ) {
                                            SurveyChart(title: "WIQ Survey", surveyType: "wiq")
                                        }
                                }
                            }
                         
                                Text("Six Minute Walk Test")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                DataCard(
                                    icon: "figure.walk",
                                    title: "Six Minute Walk Test",
                                    unit: "mi",
                                    color: Color.red
                                )
                                .padding(.vertical, 10)
                                .onTapGesture {
                                    showsixminutewalktestContentView.toggle()
                                }
                                .sheet(isPresented: $showsixminutewalktestContentView) {
                                    NavigationView {
                                        sixminutewalktestContentView()
                                            .environmentObject(firestoreManager)
                                    }
                                }
                            } .padding(.horizontal) 
                                .padding(.bottom) 
                        }
                        .scrollIndicators(.never)
                    }
                    .onAppear {
                        if let user = Auth.auth().currentUser {
                            let userUID = user.uid
                            Task {
                                await firestoreManager.fetchAllIncludingWalkTest(userUID: userUID)
                            }
                        } else {
                            print("User is not logged in.")
                        }
                        
                        //            DataCard(#imageLiteral(resourceName: "simulator_screenshot_349651C7-2510-4B06-943D-963D2708613E.png")
                        //                            icon: "figure.walk",
                        //                            title: "Six Minute Walk Test",
                        //                            unit: "mi",
                        //                            color: Color.blue
                        //                        )
                        //                        .padding(.vertical, 10)
                        //                        .onTapGesture {
                        //                            self.ContentView.toggle()
                        //                        }
                        ////                        .sheet(isPresented: $showWalkTestChart) {
                        ////                                            SixMinuteWalkTestChartView()
                        ////
                        ////                                        }
                        Spacer()
                        
                        
                        //                    // temporary fix
                        //                        .navigationBarTitle("Trends")
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
            .environmentObject(HealthKitManager())
    }
}

#endif
