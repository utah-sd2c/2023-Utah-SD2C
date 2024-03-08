//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable object_literal
// swiftlint:disable missing_docs

import Firebase
import FirebaseAuth
import FirebaseStorage
import Foundation
import ModelsR4
import ResearchKit
import SwiftUI
import UtahSharedContext

public enum SixMinuteWalkTestUtil {
    public static func addInstructionSteps(steps: inout [ORKStep]) {
        // Instruction steps
        let instructionStep = ORKInstructionStep(identifier: "SixMinuteWalkInstructionStep1")
        instructionStep.title = "Patient Questionnaire"
        instructionStep.text = """
        This information will help your doctors keep track of how you feel and how well you are able to do your usual activities. If you are unsure about how to answer a question, please give the best answer you can.

        You will be asked to complete this questionnaire at regular intervals to track your progress over time. You will be able to view your progress in the trends tab.
        """

        steps += [instructionStep]
        
    }
    
    public static func addActiveStep(steps: inout [ORKStep]) {
        
        let q11Step = SixMinuteWalkStep(identifier: "SixMinuteWalkActiveStep")
        q11Step.isOptional = false

        steps += [q11Step]
    }
    
    
}
