//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SwiftUI
import Charts

struct DistanceTraveledChart: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State var chartData: [DistanceData] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Distance Traveled")
                    .font(.headline)
                Chart {
                    ForEach(chartData) { datum in
                        BarMark(
                            x: .value("Date", formatDate(datum.date)),
                            y: .value("Distance Traveled (mi)", datum.distance)
                        )
                        .annotation(position: .top) {
                            Text("\(datum.distance, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .chartYAxisLabel(position: .leading) {
                    Text("Total Daily Distance Traveled (mi)")
                        .font(.subheadline)
                }
                .chartXAxis {
                    AxisMarks(values: chartData.map { formatDate($0.date) }) { value in
                        AxisValueLabel {
                            if let dateValue = value.as(String.self) {
                                Text(dateValue)
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        }
        .onAppear {
            fetchAndSetDistanceData()
        }
    }

    // Function to get the distance data asap
    func fetchAndSetDistanceData() {
        Task {
            await healthKitManager.fetchDistanceData()
            DispatchQueue.main.async {
                self.chartData = self.healthKitManager.distanceData.suffix(7)
            }
        }
    }
}
    
func formatDate(_ date: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MM/dd"

    if let date = inputFormatter.date(from: date) {
        return outputFormatter.string(from: date)
    } else {
        return date 
    }
}

struct DistanceTraveledChart_Previews: PreviewProvider {
    static var previews: some View {
        DistanceTraveledChart()
            .environmentObject(HealthKitManager())
    }
}
