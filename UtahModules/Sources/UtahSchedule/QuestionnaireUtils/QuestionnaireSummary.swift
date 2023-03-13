//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// swiftlint:disable force_unwrapping

import SwiftUI

struct QuestionnaireSummary: View {
    @ObservedObject var delegate: SheetDismisserProtocol
    let userScore: Double
    let minScore: Double
    let maxScore: Double
    let healthCategory: String
    
    var body: some View {
        VStack {
            Text(healthCategory + ".")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 80)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("It looks like...")
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            StyledGauge(userScore: userScore, minScore: minScore, maxScore: maxScore)
                .padding()
                .frame(minWidth: 150, maxWidth: 250)
            Spacer()
            Text("You can view your progress in the trends tab.")
                .padding(.vertical, 15)
            Button(action: {
                self.delegate.dismiss()
            }) {
                Text("Done")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
            .padding(.horizontal, 20)
        }.padding(.top, 20)
            .padding(.bottom, 30)
    }
}
