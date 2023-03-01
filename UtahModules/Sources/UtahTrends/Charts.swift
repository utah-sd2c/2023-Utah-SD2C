//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Charts
import SwiftUI

// Edmonton frail scale
struct EFS: Identifiable {
    let date: String
    let score: Int
    var id = UUID()
}

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


// dummy data
let efsDummyData: [EFS] = [
    .init(date: "January", score: 15),
    .init(date: "February", score: 17),
    .init(date: "March", score: 3),
    .init(date: "April", score: 8),
    .init(date: "May", score: 9)
]

var stepDummyData: [StepCount] = [
    .init(date: "MON", count: 5000),
    .init(date: "TUES", count: 6000),
    .init(date: "WED", count: 3809),
    .init(date: "THURS", count: 4072),
    .init(date: "FRI", count: 12000),
    .init(date: "SAT", count: 220),
    .init(date: "SUN", count: 2000)
]


struct Charts: View {
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
                Spacer()
                Text("Edmonton Frail Scale")
                    .font(.headline)
                    .padding(.top)
                Chart {
                    ForEach(efsDummyData) { datum in
                        BarMark(
                            x: .value("Date", datum.date),
                            y: .value("Edmonton Frail Scale Score", datum.score)
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

struct Chart_Previews: PreviewProvider {
    static var previews: some View {
        Charts()
    }
}
