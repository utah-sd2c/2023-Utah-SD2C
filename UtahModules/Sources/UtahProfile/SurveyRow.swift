//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import SwiftUI

struct SurveyRow: View {
    var dateCompleted: Date
    let dateFormatter = DateFormatter()
    
    var body: some View {
        Text(dateCompleted, format: .dateTime)
    }
}

// struct SurveyRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SurveyRow(surveyHistory: surveyHistory[0])
//    }
// }
