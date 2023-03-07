//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: Emmy Thamakaison
//
// SPDX-License-Identifier: MIT
// This code has been copied and modified from Tobia Tiemerding's original code from this repository: https://github.com/honkmaster/TTGaugeView

import Foundation
import SwiftUI

struct StyledGauge: View {
    let userScore: Double
    let minScore: Double
    let maxScore: Double
    
    // let gaugeDescription = "Risk Gauge"
    let gradient = Gradient(colors: [.green, .yellow, .orange, .red])
    
    let angle: Double = 260.0
    let sections: [TTGaugeViewSection] = [
        TTGaugeViewSection(color: .green, size: 0.333),
        TTGaugeViewSection(color: .yellow, size: 0.333),
        TTGaugeViewSection(color: .red, size: 0.333)
    ]
    
    var body: some View {
        TTGaugeView(
            angle: angle,
            sections: sections,
            userValue: userScore,
            maxValue: maxScore,
            minValue: minScore
        )
        
//        Gauge(value: userScore, in: minScore...maxScore) {
//            Image(systemName: "heart.fill")
//                .foregroundColor(.red)
//        } currentValueLabel: {
//            Text("\(Int(userScore))")
//                .foregroundColor(Color.green)
//        } minimumValueLabel: {
//            Text("\(Int(minScore))")
//                .foregroundColor(Color.green)
//        } maximumValueLabel: {
//            Text("\(Int(maxScore))")
//                .foregroundColor(Color.red)
//        }
//        .gaugeStyle(.accessoryCircular)
//        .tint(gradient)
//        Spacer()
        
    }
}

struct StyledGauge_Previews: PreviewProvider {
    static var previews: some View {
        StyledGauge(userScore: 50.0, minScore: 50, maxScore: 160)
    }
}
