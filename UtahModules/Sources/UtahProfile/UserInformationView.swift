//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct UserInformationView: View {
    @State private var email = "jane@example.com"
    @Binding var disease: String
    @State private var needHelp = false
    @State private var logOut = false
    let diseaseOptions = ["Peripheral Arterial Disease", "Venous Insufficiency", "I'm not sure"]

    var body: some View {
        VStack {
            InfoRow(field: "EMAIL", value: $email)
            InfoRow(field: "CONDITION", value: $disease)
            Spacer()
            MenuButton(eventBool: $needHelp, buttonLabel: "Need help?", foregroundColor: Color.accentColor, backgroundColor: Color(.white))
                .sheet(isPresented: $needHelp) {
                    HelpPage()
                }
                .padding(.bottom, -15)
            MenuButton(eventBool: $logOut, buttonLabel: "Logout", foregroundColor: Color(.white), backgroundColor: Color.accentColor)
                .sheet(isPresented: $needHelp) {
                    FormView(disease: $disease, isEditing: $needHelp)
                }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
}
