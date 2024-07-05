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
                            x: .value("Date", datum.date),
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
                    AxisMarks(values: chartData.map { $0.date }) { value in
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
            fetchDistanceData()
        }
    }

    func fetchDistanceData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chartData = self.healthKitManager.distanceData.suffix(7)
        }
    }
}

struct DistanceTraveledChart_Previews: PreviewProvider {
    static var previews: some View {
        DistanceTraveledChart()
            .environmentObject(HealthKitManager())
    }
}
