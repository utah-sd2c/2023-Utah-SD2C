//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable line_length

import Charts
import FirebaseFirestore
import SwiftUI
import UtahSharedContext

struct SurveyChart: View {
    @StateObject var edmontonChartData = EdmontonChartData()
    @EnvironmentObject var firestoreManager: FirestoreManager
    let title: String
    let surveyType: String
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text(title)
                    .font(.headline)
                    .padding(.top)
                if surveyType == "edmonton" {
                    Text("Lower Score is Better!")
                        .font(.subheadline)
                        .italic()
                }
                Chart {
                    ForEach(edmontonChartData.firstDataForEachMonth(inMonths: 6, from: [surveyType: firestoreManager.surveys[surveyType] ?? []])) { datum in
                        BarMark(
                            x: .value("Date", datum.month),
                            y: .value("\(title) Score", datum.score)
                        )
                    }
                }
                .chartYAxisLabel(position: .leading) {
                    Text("Survey Score")
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
    }
}
