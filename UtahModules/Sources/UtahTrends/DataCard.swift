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
import FHIR
import FirebaseFirestore
import SwiftUI
import UtahSharedContext


struct DataCard: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    let icon: String
    let title: String
    let unit: String
    let color: Color
    @State private var chartData: [(date: Date, value: Double)] = []
    @State private var maxValue: Double = 0.0

    
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
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                Text(round(maxValue).description)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .accessibility(identifier: "\(unit)_val")
                Text(unit)
                Spacer()
            }
        }
        .padding(30)
        .frame(width: 350, height: 110)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        }
        .task {
            if title == "Daily Step Count" {
                await firestoreManager.loadObservations(metricCode: "55423-8")
                recalculateChartData(basedon: firestoreManager.observations)
            } else if title == "Edmonton Frail Scale" {
                await firestoreManager.loadSurveys()
                getSurveyData(surveyType: "edmonton")
            } else if title == "Veines Survey Score" {
                await firestoreManager.loadSurveys()
                getSurveyData(surveyType: "veines")
            }
        }
    }
    
    func getSurveyData(surveyType: String) {
        let data = firestoreManager.surveys[surveyType]
        // get the most reason data
        let mostRecentSurvey: (dateCompleted: Date, score: Int, surveyId: String)? = data?.sorted(by: { $0.dateCompleted > $1.dateCompleted }).first
        let score = mostRecentSurvey?.score ?? 0
        self.maxValue = Double(score)
        print("my print statement:", self.maxValue)
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

/*struct DataCard_Previews: PreviewProvider {
    static var previews: some View {
        DataCard(icon: "shoeprints.fill", title: "Daily Step Count", unit: "steps", color: Color.green, observations: [])
    }
}
*/
