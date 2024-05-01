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
enum EdmontonTask {
    static func createEdmontonTask(showSummary: Bool = false) -> ORKOrderedTask {
        var steps = [ORKStep]()

        QuestionnaireUtil.addEdmontonSteps(steps: &steps)
        
        // determining what additional questionnaire to add
        // based on patients disease
        var identifier = "edmonton"
        let defaults = UserDefaults.standard
        if let disease = defaults.string(forKey: "disease") {
            switch disease {
            case StorageKeys.conditions[0]:
                QuestionnaireUtil.addWIQSteps(steps: &steps)
                identifier += "Wiq"
            case StorageKeys.conditions[1]:
                QuestionnaireUtil.addVEINESSteps(steps: &steps)
                identifier += "Veines"
            case StorageKeys.conditions[2]:
                // For "I don't know" patients, give all questions
                QuestionnaireUtil.addWIQSteps(steps: &steps)
                QuestionnaireUtil.addVEINESSteps(steps: &steps)
                identifier += "WiqVeines"
            default:
                break
            }
        }

        return ORKOrderedTask(identifier: identifier, steps: steps)
    }
}
