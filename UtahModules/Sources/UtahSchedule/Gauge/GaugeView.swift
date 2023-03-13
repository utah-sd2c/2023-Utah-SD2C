//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: Emmy Thamakaison
//
// SPDX-License-Identifier: MIT
// This code has been adapted from from Tobia Tiemerding's original code from this repository: https://github.com/honkmaster/TTGaugeView
// swiftlint:disable type_contents_order

import SwiftUI

struct GaugeElement: View {
    var section: TTGaugeViewSection
    var startAngle: Double
    var trim: ClosedRange<CGFloat>
    var lineCap: CGLineCap = .butt
    
    var body: some View {
        GeometryReader { geometry in
            let lineWidth = geometry.size.width / 12
            
            section.color
                .mask(
                    Circle()
                        .trim(from: trim.lowerBound, to: trim.upperBound)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                        .rotationEffect(Angle(degrees: startAngle))
                        .padding(lineWidth / 2)
                )
        }
    }
}

struct NeedleView: View {
    var angle: Double
    var userValue: Double = 0.0
    var maxValue: Double
    var minValue: Double
    
    var body: some View {
        // 90 to start in south orientation, then add offset to keep gauge symetric
        let startAngle = angle - 120
        let needleAngle = startAngle + (((maxValue - minValue) - (maxValue - userValue)) / (maxValue - minValue)) * angle
        
        GeometryReader { geometry in
            ZStack {
                let rectWidth = geometry.size.width / 4
                let rectHeight = geometry.size.width / 23
                
                Rectangle()
                    .fill(Color.black.opacity(0.8))
                    .cornerRadius(rectWidth / 2)
                    .frame(width: rectWidth, height: rectHeight)
                    .offset(x: rectWidth / 2)
                
                Circle()
                    .frame(width: geometry.size.width / 15)
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .rotationEffect(Angle(degrees: needleAngle))
    }
}


public struct TTGaugeView: View {
    var angle: Double
    var sections: [TTGaugeViewSection]
    var userValue: Double
    var maxValue: Double
    var minValue: Double
    var valueDescription: String?
    var gaugeDescription: String?
    
    public init(
        angle: Double,
        sections: [TTGaugeViewSection],
        userValue: Double,
        maxValue: Double,
        minValue: Double,
        valueDescription: String? = nil,
        gaugeDescription: String? = nil
    ) {
        self.angle = angle
        self.sections = sections
        self.userValue = userValue
        self.maxValue = maxValue
        self.minValue = minValue
        self.valueDescription = valueDescription
        self.gaugeDescription = gaugeDescription
    }
    
    public var body: some View {
        // 90 to start in south orientation, then add offset to keep gauge symetric
        let startAngle = 90 + (360.0 - angle) / 2.0
        
        ZStack {
            ForEach(sections) { section in
                // Find index of current section to sum up already covered areas in percent
                if let index = sections.firstIndex(where: { $0.id == section.id }) {
                    let alreadyCovered = sections[0..<index].reduce(0) { $0 + $1.size }
                    
                    // 0.001 is a small offset to fill a gap
                    let sectionSize = section.size * (angle / 360.0)// + 0.001
                    let sectionStartAngle = startAngle + alreadyCovered * angle
                    
                    GaugeElement(section: section, startAngle: sectionStartAngle, trim: 0...CGFloat(sectionSize))
                    
                    // Add round caps at start and end
                    if index == 0 || index == sections.count - 1 {
                        let capSize: CGFloat = 0.001
                        let startAngle: Double = index == 0 ? sectionStartAngle : startAngle + angle
                        
                        GaugeElement(
                            section: section,
                            startAngle: startAngle,
                            trim: 0...capSize,
                            lineCap: .round
                        )
                    }
                }
            }
            .overlay(
                VStack {
                    if let valueDescription = valueDescription {
                        Text(valueDescription)
                            .font(.title)
                            .padding()
                    }
                    if let gaugeDescription = gaugeDescription {
                        Text(gaugeDescription)
                            .font(.caption)
                    }
                }, alignment: .bottom
            )
            
            NeedleView(angle: angle, userValue: userValue, maxValue: maxValue, minValue: minValue)
        }
    }
}
