//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Charts
import FHIR
import FirebaseFirestore
import SwiftUI
import UtahSharedContext

struct StepCount: Identifiable {
    let date: String
    let count: Int
    var id = UUID()
}

// Date converter to string
func date_formatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.dateFormat = "MM/dd"
    let formatted = dateFormatter.string(from: date)
    return formatted
}

var stepDummyData: [StepCount] = [
    .init(date: "03/11", count: 2301),
    .init(date: "03/12", count: 4332),
    .init(date: "03/13", count: 3809),
    .init(date: "03/14", count: 1072),
    .init(date: "03/15", count: 1290),
    .init(date: "03/16", count: 2212),
    .init(date: "03/17", count: 3010)
]


struct StepCountChart: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var chartData: [StepCount] = []

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Step Count")
                    .font(.headline)
                Chart {
                    ForEach(chartData) { datum in
                        BarMark(
                            x: .value("Date", datum.date),
                            y: .value("Step Count", datum.count)
                        )
                    }
                }
                .chartYAxisLabel(position: .leading) {
                    Text("Total Daily Step Count")
                        .font(.subheadline)
                }
            }
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        }
        .task {
            group(firestoreManager.observations)
        }
    }
    
    func group(_ data: [(date: Date, value: Double)]) {
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
        self.chartData = filteredData.map { .init(date: date_formatter(date: $0.0), count: Int($0.1)) } as [StepCount]
        }
}

struct StepCountChart_Previews: PreviewProvider {
    static var previews: some View {
        StepCountChart()
    }
}
