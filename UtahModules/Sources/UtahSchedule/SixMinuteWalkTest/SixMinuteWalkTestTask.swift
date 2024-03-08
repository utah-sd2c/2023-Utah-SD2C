//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ResearchKit
import UtahSharedContext

// swiftlint:disable function_body_length line_length object_literal
enum SixMinuteWalkTestTask {
    static func createSixMinuteWalkTestTask(showSummary: Bool = false) -> ORKOrderedTask {
        var steps = [ORKStep]()

        SixMinuteWalkTestUtil.addInstructionSteps(steps: &steps)
        SixMinuteWalkTestUtil.addActiveStep(steps: &steps)
        

        return ORKOrderedTask(identifier: "SixMinuteWalkTestTask", steps: steps)
    }
}
