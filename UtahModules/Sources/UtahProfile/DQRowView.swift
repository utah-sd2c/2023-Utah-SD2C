//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable multiline_arguments_brackets

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
    @EnvironmentObject var firestoreManager: FirestoreManager
    let surveyType: String
    let score: Int
    var answerList: [QuestionListItem] {
        switch surveyType {
        case "veines":
            return wiqVeinesQList()
        case "edmonton":
            return edmontonQList()
        case "wiq":
            return wiqVeinesQList()
        default:
            return []
        }
    }
    let questionnaireResponse: QuestionnaireResponse
    var body: some View {
        ScrollView {
            VStack {
                Text(surveyType.uppercased())
                    .font(.title)
                    .padding(.all, 10)
                    .background(Rectangle()
                        .fill(Color.accentColor)
                        .shadow(radius: 3)
                        .cornerRadius(15)
                    )
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Spacer()
                VStack {
                    Color.gray.frame(height: 1 / UIScreen.main.scale)
                }
                ForEach(answerList, id: \.self) { item in
                    VStack {
                        Spacer()
                        Text(item.questionDescription ?? "")
                            .font(.title2)
                            .foregroundColor(Color.accentColor)
                        
                        Spacer()
                        Text(item.answer)
                            .font(.title3)
                        Spacer()
                    }
                }
            }
            .padding(10)
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
        let secondQuestion = QuestionListItem(questionDescription: "Score", answer: String(self.score))
        edmontonList.append(secondQuestion)
        let scoreDescription = QuestionListItem(questionDescription: "What your score means", answer: "0-6: Healthy - few health concerns.")
        edmontonList.append(scoreDescription)
        let scoreDescription2 = QuestionListItem(questionDescription: nil, answer: "\n6-11: Vulnerable - some health concerns; extra support & care.")
        edmontonList.append(scoreDescription2)
        let scoreDescription3 = QuestionListItem(questionDescription: nil, answer: "\n12-17: Frail - significant health concerns; daily tasks help")
        edmontonList.append(scoreDescription3)
        return edmontonList
    }
    
    func wiqVeinesQList() -> [QuestionListItem] {
        var wiqVeinesQList: [QuestionListItem] = []
        let scoreDisplay = QuestionListItem(questionDescription: "Score", answer: String(self.score))
        wiqVeinesQList.append(scoreDisplay)
        return wiqVeinesQList
    }
}
