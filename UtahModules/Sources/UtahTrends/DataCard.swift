//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// Group and recalculateChartData function pulled from CardinalKit FHIRChart module


// swiftlint:disable large_tuple
// swiftlint:disable sorted_first_last

import Charts
import FirebaseFirestore
import SwiftUI
import UtahSharedContext
import FirebaseAuth


struct DataCard: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    let icon: String
    let title: String
    let unit: String
    let color: Color
    @State private var chartData: [(date: Date, value: Double)] = []
    @State private var maxValue: Double = 0.0
    @State private var distance: Double = 0.0
    @State private var steps: Int = 0
    @State private var restCount: Int = 0
    @State private var averageDistance: Double = 0.0
    @State private var averageSteps: Double = 0.0
    
    
    var body: some View {
        VStack(alignment: .center) {
            // title
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            .padding(.bottom, 2)
            // data
            
            if title == "Six Minute Walk Test" {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        Spacer()
                        VStack {
                            Text(String(format: "%.2f", convertToMiles(meters: distance)))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(color)
                                .accessibility(identifier: "\(unit)_val")
                            Text(unit)
                        }
                        Spacer()
                        VStack {
                            Text("\(steps)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(color)
                                .accessibility(identifier: "steps_val")
                            Text("steps")
                        }
                        Spacer()
                        VStack {
                            Text("\(restCount)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(color)
                                .accessibility(identifier: "rest_val")
                            Text("rests")
                        }
                        Spacer()
                        Image(systemName: "chevron.up")
                    }
                }
                .onAppear {
                    Task {
                        await getSixMinuteWalkTestData()
                    }
                }
                
            } else if title == "Average Distance Traveled" {
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    Text(String(format: "%.2f", averageDistance))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                        .accessibility(identifier: "\(unit)_val")
                    Text("miles") // Change "mi" to "miles"
                    Spacer()
                    Image(systemName: "chevron.up")
                }
            
                .onAppear {
                    Task {
                        await getAverageDistanceData()
                    }
                }
        }
            else if title == "Average Step Count" {
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    Text(String(format: "%.0f", averageSteps))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                        .accessibility(identifier: "\(unit)_val")
                    Text("steps")
                    Spacer()
                    Image(systemName: "chevron.up")
                }
                .onAppear {
                    Task {
                        await getAverageStepData()
                    }
                }
            }
                else {
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    Text(Int(maxValue).description)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                        .accessibility(identifier: "\(unit)_val")
                    Text(unit)
                    Spacer()
                    Image(systemName: "chevron.up")
                }
            }
        }
        .padding(30)
        .frame(width: 350, height: title == "Six Minute Walk Test" ? 130 : 110) // Adjust the height for the "Six Minute Walk Test"
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        }
        .task {
            if title == "Average Step Count" {
//                await firestoreManager.loadObservations(metricCode: "55423-8")
//                recalculateChartData(basedon: firestoreManager.observations)
                await getAverageStepData()
            }
            else if title == "Latest EFS Score" {
                await firestoreManager.loadSurveys()
                getSurveyData(surveyType: "edmonton")
            } else if title == "Veines Survey Score" {
                await firestoreManager.loadSurveys()
                getSurveyData(surveyType: "veines")
            } else if title == "WIQ Survey Score" {
                await firestoreManager.loadSurveys()
                getSurveyData(surveyType: "wiq")
            }else if title == "Six Minute Walk Test" {
                await getSixMinuteWalkTestData()
            }
            else if title == "Average Distance Traveled" {
                await getAverageDistanceData()
            }
//            else if title == "Average Step Count1" {
//                await getAverageStepData()
//            }
            
        }
    }
    
    private func convertToMiles(meters: Double) -> Double {
        return meters * 0.000621371
    }
    func getSurveyData(surveyType: String) {
        let data = firestoreManager.surveys[surveyType]
        // get the most reason data
        let mostRecentSurvey: (dateCompleted: Date, score: Int, surveyId: String)? = data?.sorted(by: { $0.dateCompleted > $1.dateCompleted }).first
        let score = mostRecentSurvey?.score ?? 0
        self.maxValue = Double(score)
    }
    
    // Gets the Average Distance data from the healthkitmanager file
    func getAverageDistanceData() async {
          await healthKitManager.fetchDistanceData()
          DispatchQueue.main.async {
              self.averageDistance = healthKitManager.averageDistance
          }
      }
    
    // Gets the Average Step data from the healthkitmanager file
    func getAverageStepData() async {
            await healthKitManager.fetchStepData()
            DispatchQueue.main.async {
                self.averageSteps = healthKitManager.averageSteps
            }
        }

    // Gets the latest 6MWT session
    func getSixMinuteWalkTestData() async {
         if let user = Auth.auth().currentUser {
             let userUID = user.uid
             await firestoreManager.getSixMinuteWalkTestResults(userUID: userUID)
             if let latestResult = firestoreManager.sixMinuteWalkTestResults.first {
                 self.distance = latestResult.distance
                 self.steps = latestResult.steps
                 self.restCount = latestResult.restCount
             }
         } else {
             print("User is not logged in.")
         }
     }

    
    // sums up all data points from each day
    func group(_ data: [(date: Date, value: Double)]) -> [(date: Date, value: Double)] {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
        var latestDate: Date = calendar.date(byAdding: .day, value: -6, to: startOfDay) ?? Date()
            var filteredData: [(Date, Double)] = []
            
            Calendar.current.enumerateDates(
                startingAfter: latestDate,
                matching: DateComponents(hour: 0),
                matchingPolicy: .nextTime
            ) { result, _, stop in
                guard let result else {
                    stop = true
                    return
                }
                
                let summedUpData = data
                    .filter { element in
                        latestDate < element.date && element.date < result
                    }
                    .map {
                        $0.value
                    }
                    .reduce(0.0, +)
                filteredData.append((result, summedUpData))
                
                latestDate = result
                
                if result > Date() {
                    stop = true
                }
            }
            
            return filteredData
        }
    
    // recalculates data when new observation is added
    func recalculateChartData(basedon newObservations: [(date: Date, value: Double)]) {
        chartData = group(firestoreManager.observations)
        maxValue = chartData.map { $0.value }.reduce(0, +) / 7
    }
}
extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
/*struct DataCard_Previews: PreviewProvider {
    static var previews: some View {
        DataCard(icon: "shoeprints.fill", title: "Daily Step Count", unit: "steps", color: Color.green, observations: [])
    }
}
*/
