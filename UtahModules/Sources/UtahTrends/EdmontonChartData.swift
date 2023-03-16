//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable large_tuple
// swiftlint:disable identifier_name

import Combine
import FirebaseFirestore
import Foundation
import UtahSharedContext


struct MonthScore: Identifiable {
    let id = UUID()
    let month: String
    let score: Int
}

// gets most recent measurement per month
class EdmontonChartData: ObservableObject {
    func firstDataForEachMonth(inMonths range: Int, from surveys: [String: [(dateCompleted: Date, score: Int, surveyId: String)]]) -> [MonthScore] {
        var result: [MonthScore] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"

        let calendar = Calendar.current

        // Find the most recent survey date
        let mostRecentDate = surveys.values
            .flatMap { $0 }
            .map { $0.dateCompleted }
            .max() ?? Date()

        var currentDate = mostRecentDate

        for i in 0..<range {
            if i > 0 {
                currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            }
            let currentMonth = dateFormatter.string(from: currentDate)

            // Find surveys for the current month
            let surveysForCurrentMonth = surveys.values
                .flatMap { $0 }
                .filter { dateFormatter.string(from: $0.dateCompleted) == currentMonth }
            
            if let mostRecentSurvey = surveysForCurrentMonth.max(by: { $0.dateCompleted < $1.dateCompleted }) {
                result.append(MonthScore(month: currentMonth, score: mostRecentSurvey.score))
            }
        }

        return result.sorted { monthScore1, monthScore2 in
            monthScore1.month < monthScore2.month
        }
    }
}
