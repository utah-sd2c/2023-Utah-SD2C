//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable identifier_name

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

struct DetailedQuestionnaireView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var survey: QuestionnaireResponse?
    var surveyId: String
    var type: String
    var score: Int
    
    var body: some View {
        NavigationStack {
            Spacer()
            if let survey {
                DQRowView(surveyType: type, score: score, questionnaireResponse: survey)
                    .navigationBarTitle("Previous Response")
                    .navigationTitle("[date], [type of survey]")
            } else {
                ProgressView()
            }
        }
        .task {
            survey = await querySurveys(type: type, surveyId: surveyId)
        }
    }
        
    
        func querySurveys(type: String, surveyId: String) async -> QuestionnaireResponse? {
            await withCheckedContinuation { continuation in
                let db = Firestore.firestore()
                var surveyName = "veinesssurveys"
                if type == "edmonton" {
                    surveyName = "edmontonsurveys"
                } else if type == "wiq" {
                    surveyName = "wiqsurveys"
                }
                let docRef = db.collection(surveyName).document(surveyId)
                docRef.getDocument(as: QuestionnaireResponse.self) { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        continuation.resume(with: .success(response))
                    case .failure(let error):
                        print(error)
                        continuation.resume(with: .success(nil))
                    }
                }
            }
        }
}

struct DetailedQuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedQuestionnaireView(surveyId: "", type: "", score: 0)
    }
}
