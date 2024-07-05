//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SwiftUI
import UtahSharedContext

struct sixminutewalktestContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State private var expandedItems: [Date: Bool] = [:]
 
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    // Going over the 6MWT results from FirestoreManager.
                    ForEach(firestoreManager.sixMinuteWalkTestResults, id: \.date) { result in
                        DisclosureGroup(
                            isExpanded: Binding<Bool>(
                                get: { expandedItems[result.date] ?? false },
                                set: { expandedItems[result.date] = $0 }
                            ),
                            content: {
                                VStack(alignment: .leading) {
                                    ForEach(result.restData.keys.sorted(), id: \.self) { key in
                                        if let restDocument = result.restData[key] {
                                            VStack(alignment: .leading) {
                                                Text(key == "FinalResult" ? "Final Result" : key)
                                                    .font(.headline)
                                                ForEach(restDocument.keys.sorted(), id: \.self) { field in
                                                    if field == "Distance" || field == "Steps" || field == "TimeSinceTestBegan" {
                                                        if let value = restDocument[field] {
                                                            Text("\(field): \(formatValue(field: field, value: value))")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            },
                            label: {
                                HStack {
                                    Text("Date: \(result.date, formatter: DateFormatter.shortDate)")
                                        .font(.headline)
                                        .padding()
                                    Spacer()
                                }
                                .frame(width: 350, height: 110)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(.systemBackground))
                                        .shadow(radius: 5)
                                }
                            }
                        )
                        .padding(.bottom, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("6MWT Results")
        }
    }

    // Function to format the values for display.
    private func formatValue(field: String, value: Any) -> String {
        if field == "Distance" {
            return "\(String(format: "%.2f", convertToMiles(meters: value as? Double ?? 0.0))) miles"
        } else if field == "TimeSinceTestBegan" {
            return formatMinutesAndSeconds(seconds: value as? Double ?? 0.0)
        } else {
            return String(describing: value)
        }
    }

    // Function to convert meters to miles.
    private func convertToMiles(meters: Double) -> Double {
        return meters * 0.000621371
    }

    // Function to format seconds into minutes and seconds.
    private func formatMinutesAndSeconds(seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return "\(minutes) mins and \(remainingSeconds) seconds"
    }
}

struct sixminutewalktestContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        sixminutewalktestContentView()
                .environmentObject(FirestoreManager())
        }
    }
}

