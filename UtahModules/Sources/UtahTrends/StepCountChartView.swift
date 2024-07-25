//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Charts
import FirebaseFirestore
import SpeziFHIR
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
                        .annotation(position: .top) {
                                                    Text("\(datum.count)")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                }
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
    // Old way of filtering and displaying data
//    func group(_ data: [(date: Date, value: Double)]) {
//               let calendar = Calendar.current
//               let startOfDay = calendar.startOfDay(for: Date())
//           var latestDate: Date = calendar.date(byAdding: .day, value: -6, to: startOfDay) ?? Date()
//               var filteredData: [(Date, Double)] = []
//
//               Calendar.current.enumerateDates(
//                   startingAfter: latestDate,
//                   matching: DateComponents(hour: 0),
//                   matchingPolicy: .nextTime
//               ) { result, _, stop in
//                   guard let result else {
//                       stop = true
//                       return
//                   }
//
//                   let summedUpData = data
//                       .filter { element in
//                           latestDate < element.date && element.date < result
//                       }
//                       .map {
//                           $0.value
//                       }
//                       .reduce(0.0, +)
//                   filteredData.append((result, summedUpData))
//
//                   latestDate = result
//
//                   if result > Date() {
//                       stop = true
//                   }
//               }
//           self.chartData = filteredData.map { .init(date: date_formatter(date: $0.0), count: Int($0.1)) } as [StepCount]
//           }
//   }

   // New way of filtering and displaying data
    func group(_ data: [(date: Date, value: Double)]) {
        print("Received data:", data)
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
//        let latestDate: Date = startOfDay
        let latestDate: Date = Date()
        var endDate: Date = calendar.date(byAdding: .day, value: -7, to: startOfDay)!
        var filteredData: [(String, Double)] = []
        
//        while endDate < latestDate {
        while endDate <= latestDate {
            let startDate = calendar.startOfDay(for: endDate)
            let nextDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            print("Processing day from \(startDate) to \(nextDate)")
            
            let filteredDataForDate = data.filter { entry in
                return startDate <= entry.date && entry.date < nextDate
            }
            
            print("Filtered data for \(startDate): \(filteredDataForDate)")
            
            
            let summedUpData = filteredDataForDate.map { $0.value }.reduce(0.0, +)
            print("Summed up data for \(startDate): \(summedUpData)")
            
            let dateString = date_formatter(date: startDate)
            filteredData.append((dateString, summedUpData))
            
            endDate = nextDate
        }
        
        self.chartData = filteredData.map { StepCount(date: $0.0, count: Int($0.1)) }
        print("Final chart data:", self.chartData)
    }
}
    struct StepCountChart_Previews: PreviewProvider {
        static var previews: some View {
            StepCountChart()
        }
    }
