//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Charts
import SwiftUI

// Step count
struct StepCount: Identifiable {
    let date: String
    let count: Int
    var id = UUID()
}

// Date converter to string
func date_formatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    let formatted = dateFormatter.string(from: date)
    return formatted
}

var stepDummyData: [StepCount] = [
    .init(date: "MON", count: 5000),
    .init(date: "TUES", count: 6000),
    .init(date: "WED", count: 3809),
    .init(date: "THURS", count: 4072),
    .init(date: "FRI", count: 12000),
    .init(date: "SAT", count: 220),
    .init(date: "SUN", count: 2000)
]


struct StepCountChart: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Step Count")
                    .font(.headline)
                Chart {
                    ForEach(stepDummyData) { datum in
                        BarMark(
                            x: .value("Date", datum.date),
                            y: .value("Step Count", datum.count)
                        )
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
    }
}

struct StepCountChart_Previews: PreviewProvider {
    static var previews: some View {
        StepCountChart()
    }
}
