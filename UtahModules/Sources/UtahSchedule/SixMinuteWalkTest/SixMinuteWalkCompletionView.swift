//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable force_unwrapping
// swiftlint:disable type_contents_order
import Foundation
import ResearchKit
import SwiftUI
import UIKit

public class SixMinuteWalkCompletionView: ORKCompletionStepViewController {
    
    override public init(step: ORKStep?) {
        super.init(step: step)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Putting this here doesn't work, since you can't edit step from here; find somewhere to put it that can update text...
        if let activeStepResult = taskViewController?.result.stepResult(forStepIdentifier: SixMinuteWalkTestUtil.activeStepIdentifier) {
            step!.text! += "\nDebugData:\n"
            let results = activeStepResult.results as? [SixMinuteWalkStepResult]
            for entry in results! {
                step!.text! += "\tSteps: " + String(describing: entry.steps)
                step!.text! += " Distance: " + String(describing: entry.distance)
                step!.text! += " RelativeTime: " + String(describing: entry.relativeTime)
                step!.text! += " AbsoluteTime: " + String(describing: entry.absoluteTime)
            }
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
