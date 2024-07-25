//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT

import SwiftUI
import Charts

struct StepCountChartnew: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State var chartData: [StepData] = []
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Step Count")
                    .font(.headline)
                Chart {
                    ForEach(chartData) { datum in
                        BarMark(
                            x: .value("Date", formatDate(datum.date)),
                            y: .value("Steps", datum.steps)
                        )
                        .annotation(position: .top) {
                            Text("\(datum.steps)")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .chartYAxisLabel(position: .leading) {
                    Text("Total Daily Steps")
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
            fetchAndSetStepData()
            startTimer()
        }
        .onDisappear {
                   stopTimer()
               }
    }

    func fetchAndSetStepData() {
           Task {
               await healthKitManager.fetchStepData()
               DispatchQueue.main.async {
                   self.chartData = Array(self.healthKitManager.stepData.suffix(7))
               }
           }
       }
    func startTimer() {
           timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
               fetchAndSetStepData()
           }
       }

       func stopTimer() {
           timer?.invalidate()
           timer = nil
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
}

struct StepCountChartnew_Previews: PreviewProvider {
    static var previews: some View {
        StepCountChartnew()
            .environmentObject(HealthKitManager())
    }
}
