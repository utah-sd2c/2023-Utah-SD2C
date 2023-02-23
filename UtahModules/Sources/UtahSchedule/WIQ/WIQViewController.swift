//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
import SwiftUI
import UIKit

struct WIQViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> WIQViewCoordinator {
        WIQViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let wiqSurveyTask: ORKOrderedTask = {
            var steps = [ORKStep]()
            
            let instruction = ORKInstructionStep(identifier: "WIQ")
                    instruction.title = "Walking Impairement Questionnaire"
                    instruction.text = "Patient Mobility Assessment"
                    
                    steps += [instruction]

                    let wiqChoices = [
                        ORKTextChoice(text: "No Difficulty", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Slight Difficulty", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Some Difficulty", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Much Difficulty", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Unable to Do", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let wiqAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: wiqChoices)
                    
                    let questions = [
                        "Walk indoors, such as around your home?", "Walk 50 feet?", "Walk 150 feet? (1/2 block)",
                        "Walk 300 feet? 1 block?", "Walk 600 feet? 2 blocks?", "Walk 900 feet? 3 blocks?", "Walk 1500 feet? 5 blocks?"
                    ]
                    for (idx, question) in questions.enumerated() {
                        let wiq = ORKQuestionStep(
                            identifier: String(format: "WIQ Endurance %d", idx + 1),
                            title: "How difficult was it for you to:",
                            question: question,
                            answer: wiqAnswerFormat
                        )
                        wiq.isOptional = false
                        steps += [wiq]
                    }
                    
                    // SUMMARY
                    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
                    summaryStep.title = "Thank you."
                    summaryStep.text = "We appreciate your time."
                    steps += [summaryStep]
                    
                    return ORKOrderedTask(identifier: "WIQ", steps: steps)
        }()
        
        let taskViewController = ORKTaskViewController(task: wiqSurveyTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        
        // & present the VC!
        return taskViewController
    }
}
