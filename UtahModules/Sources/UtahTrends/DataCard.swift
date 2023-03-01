//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// Group and recalculateChartData function pulled from CardinalKit FHIRChart module


import Charts
import FHIR
import SwiftUI


struct DataCard: View {
    let icon: String
    let title: String
    let unit: String
    let color: Color
    let observations: [Observation]
    
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
                Text(maxValue.description)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .accessibility(identifier: "\(unit)_val")
                Text(unit)
                Spacer()
            }
        }
        // .frame(width: 380)
        .padding(30)
        .frame(width: 350, height: 110)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        }
        .task {
            recalculateChartData(basedOn: observations)
        }
    }
    
    // sums up all data points from current day
    func group(_ data: [(date: Date, value: Double)]) -> [(date: Date, value: Double)] {
            var latestDate: Date = Calendar.current.startOfDay(for: Date())
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
    func recalculateChartData(basedOn newObservations: [Observation]) {
            chartData = group(
                observations
                    .compactMap { observation in
                        observation.chartData
                    }
                )
            maxValue = chartData
                .max {
                    $0.value < $1.value
                }?
                .value ?? 0.0
        }
}

struct DataCard_Previews: PreviewProvider {
    static var previews: some View {
        DataCard(icon: "shoeprints.fill", title: "Daily Step Count", unit: "steps", color: Color.green, observations: [])
    }
}
