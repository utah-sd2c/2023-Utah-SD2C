//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable type_contents_order
import Foundation
import ResearchKit
import SwiftUI
import UIKit

public class SixMinuteWalkCompletionStep: ORKCompletionStep {
        
    override public class func stepViewControllerClass() -> AnyClass {
        SixMinuteWalkCompletionView.self
    }
    
    override public init(identifier: String) {
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

