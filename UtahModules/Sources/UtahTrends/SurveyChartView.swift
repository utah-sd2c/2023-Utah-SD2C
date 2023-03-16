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


// dummy data
let efsDummyData: [EFS] = [
    .init(date: "January", score: 15),
    .init(date: "February", score: 17),
    .init(date: "March", score: 3),
    .init(date: "April", score: 8),
    .init(date: "May", score: 9)
]

struct SurveyChart: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                    .padding(.top)
                Chart {
                    ForEach(efsDummyData) { datum in
                        BarMark(
                            x: .value("Date", datum.date),
                            y: .value("\(title) Score", datum.score)
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

struct EdmontonChart_Previews: PreviewProvider {
    static var previews: some View {
        SurveyChart(title: "Edmonton Frail Scale")
    }
}
