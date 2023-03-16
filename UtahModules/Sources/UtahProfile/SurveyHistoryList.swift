//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import FHIR
import Foundation
import SwiftUI
import UtahSharedContext

struct SurveyHistoryList: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var surveys: [QuestionnaireResponse] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(firestoreManager.surveys.keys), id: \.self) { surveySection in
                    Section(surveySection, content: {
                        createSurveySection(surveySection: surveySection)
                    })
                    .listRowBackground(Color.accentColor)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Survey History")
            .task {
                await firestoreManager.loadSurveys()
            }
        }
    }
    func createSurveySection(surveySection: String) -> some View {
        ForEach(firestoreManager.surveys[surveySection] ?? [], id: \.surveyId) { survey in
            NavigationLink {
                DetailedQuestionnaireView(surveyId: survey.surveyId, type: surveySection, score: survey.score, date: survey.dateCompleted)
            } label: {
                SurveyRow(dateCompleted: survey.dateCompleted)
                    .foregroundColor(Color.white)
            }
        }
    }
}
