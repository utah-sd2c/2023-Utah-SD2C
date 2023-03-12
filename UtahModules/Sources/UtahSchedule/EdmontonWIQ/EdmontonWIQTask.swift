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
// swiftlint:disable type_body_length
enum EdmontonWIQTask {
    static func createEdmontonWIQTask(showSummary: Bool = false) -> ORKOrderedTask {
        var steps = [ORKStep]()

        // EDMONTON
        QuestionnaireUtil.addEdmontonSteps(steps: &steps)

        // WIQ
        QuestionnaireUtil.addWIQSteps(steps: &steps)
        
        // summary
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "You can view your progress in the trends tab."

        steps += [summaryStep]


        return ORKOrderedTask(identifier: "edmontonWiq", steps: steps)
    }
}
