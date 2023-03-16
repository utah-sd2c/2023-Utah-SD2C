////
//// This source file is part of the CS342 2023 Utah Team Application project
////
//// SPDX-FileCopyrightText: 2023 Stanford University
////
//// SPDX-License-Identifier: MIT
////
//
//// swiftlint:disable line_length
// import Charts
// import SwiftUI
// import FirebaseFirestore
// import UtahSharedContext
//
// struct EdmontonChart: View {
//    @StateObject var edmontonChartData = EdmontonChartData()
//    @EnvironmentObject var firestoreManager: FirestoreManager
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .center) {
//                Text("Edmonton Frail Scale")
//                    .font(.headline)
//                    .padding(.top)
//                Chart {
//                    ForEach(edmontonChartData.firstDataForEachMonth(inMonths: 6, from: ["edmonton": firestoreManager.surveys["edmonton"] ?? []])) { datum in
//                        BarMark(
//                            x: .value("Date", datum.month),
//                            y: .value("Edmonton Frail Scale Score", datum.score)
//                        )
//                    }
//                }
//            }
//        }
//        .padding(30)
//        .background {
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(Color(.systemBackground))
//                .shadow(radius: 5)
//        }
//    }
// }
