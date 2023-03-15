//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable multiline_literal_brackets

import Account
import FHIR
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI
import UtahSharedContext

struct DQRowView: View {
    // questions and answers in same array
    
    // turn this into dictionary: q1:"Drawing Clock Test"
    @EnvironmentObject var firestoreManager: FirestoreManager
    var questionList =
    [
        "q1": "Drawing Clock Test",
        "q2": "Times admitted to a hospital the past year",
        "q3": "Description of overall health"
    ]
    let surveyType: String
    let score: Int
    var answerList: [QuestionListItem] {
        switch surveyType {
        case "veinesssurveys":
            return veinesQList()
        case "edmonton":
            return edmontonQList()
        case "wiq":
            return wiqQList()
        default:
            return []
        }
    }
    let questionnaireResponse: QuestionnaireResponse
    var body: some View {
        ScrollView {
            ForEach(answerList, id: \.self) { item in
                Text(item.questionDescription)
                    .padding(.all, 10)
                    .background(
                        Rectangle()
                        .fill(Color.accentColor)
                        .shadow(radius: 3)
                        .cornerRadius(15)
                    )
                    .foregroundColor(.white)
                
                Spacer()
                Text(item.answer)
            }
            .font(.title)
            // call fn that returns this answer list - calls out to firebase, grabs all answers and returns tis list
        }
    }
    func edmontonQList() -> [QuestionListItem] {
        var edmontonList: [QuestionListItem] = []
        var answer: String
        if questionnaireResponse.item?[0].answer?.rawValue == nil {
            answer = "Not uploaded"
        } else {
            answer = "Uploaded successfully"
        }
        let firstQuestion = QuestionListItem(questionDescription: "Clock Test", answer: answer)
        edmontonList.append(firstQuestion)
        return edmontonList
    }
    
    func wiqQList() -> [QuestionListItem] {
        []
    }
    
    func veinesQList() -> [QuestionListItem] {
        []
    }
}
