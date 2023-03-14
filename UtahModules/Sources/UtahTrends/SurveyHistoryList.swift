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
        NavigationView {
            List {
                ForEach(Array(firestoreManager.surveys.keys), id: \.self) { surveySection in
                    Section(surveySection, content: {
                        createSurveySection(surveySection: surveySection)
                    })
                }
            }
            .task {
                await firestoreManager.loadSurveys()
            }
        }
    }
    func createSurveySection(surveySection: String) -> some View {
        ForEach(firestoreManager.surveys[surveySection] ?? [], id: \.surveyId) { survey in
            NavigationLink {
                DetailedQuestionnaireView(surveyId: survey.surveyId, type: surveySection, score: survey.score)
            } label: {
                SurveyRow(dateCompleted: survey.dateCompleted)
            }
        }
    }
}
