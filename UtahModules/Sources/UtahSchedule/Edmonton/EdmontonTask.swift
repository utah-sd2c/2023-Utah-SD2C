//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ResearchKit

// swiftlint:disable function_body_length line_length object_literal
enum EdmontonTask {
    static func createEdmontonTask(showSummary: Bool = false) -> ORKOrderedTask {
        var steps = [ORKStep]()

        QuestionnaireUtil.addEdmontonSteps(steps: &steps)
        
        if showSummary {
            let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
            summaryStep.title = "Thank you."
            summaryStep.text = "You can view your progress in the trends tab."

            steps += [summaryStep]
        }

        return ORKOrderedTask(identifier: "edmonton", steps: steps)
    }
}
