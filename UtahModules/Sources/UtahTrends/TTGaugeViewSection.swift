//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: Emmy Thamakaison
//
// SPDX-License-Identifier: MIT
// This code has been copied and modified from Tobia Tiemerding's original code from this repository: https://github.com/honkmaster/TTGaugeView

import SwiftUI

public struct TTGaugeViewSection: Identifiable {
    public var id = UUID()
    var color: Color
    var size: Double
    
    public init(color: Color, size: Double) {
        self.color = color
        self.size = size
    }
}
