//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFirestore
import SpeziAccount
import SpeziFirebaseAccount
import SpeziOnboarding
import SwiftUI
import UtahSharedContext

struct UserInformationView: View {
    let user = Auth.auth().currentUser
    var refesh = false
    @State private var needHelp = false
    @State private var logOut = false
    @State private var surveyHistory = false
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        VStack {
            InfoRow(field: "EMAIL", value: user?.email ?? "")
            InfoRow(field: "DIAGNOSIS", value: firestoreManager.disease)
            Spacer()
            MenuButton(eventBool: $surveyHistory, buttonLabel: "Survey History", foregroundColor: Color.accentColor, backgroundColor: Color(.white))
                .sheet(isPresented: $surveyHistory) {
                    SurveyHistoryList()
                }
                .padding(.bottom, -15)
            MenuButton(eventBool: $needHelp, buttonLabel: "Need help?", foregroundColor: Color.accentColor, backgroundColor: Color(.white))
                .sheet(isPresented: $needHelp) {
                    HelpPage()
                }
                .padding(.bottom, -15)
            LogoutButton(eventBool: $logOut, buttonLabel: "Logout", foregroundColor: Color(.white), backgroundColor: Color.accentColor)
                .sheet(isPresented: $needHelp) {
                    FormView(disease: $firestoreManager.disease, isEditing: $needHelp)
                }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
}
