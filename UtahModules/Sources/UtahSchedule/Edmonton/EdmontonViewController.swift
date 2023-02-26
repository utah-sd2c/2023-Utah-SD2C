//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable object_literal
// swiftlint:disable force_unwrapping

import Foundation
import ResearchKit
import SwiftUI
import UIKit

struct EdmontonViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> EdmontonViewCoordinator {
        EdmontonViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let edmontonSurveyTask: ORKOrderedTask = {
            var steps = [ORKStep]()
            
            // Instruction step
            let instructionStep = ORKInstructionStep(identifier: "IntroStep")
            instructionStep.title = "Patient Questionnaire"
            instructionStep.text = """
            This information will help your doctors keep track of how you feel and how well you are able
            to do your usual activities. If you are unsure about how to answer a question, please give the
            best answer you can and make a written comment beside your answer.
            """

            steps += [instructionStep]

            // Clock test step
            let clockTestInstructionStep = ORKInstructionStep(identifier: "ClockStep")
            clockTestInstructionStep.title = "Draw a clock"
            clockTestInstructionStep.text = """
            Place numbers the correct positions on a pre-drawn circle, and place hands to
            indicate the time of ‘ten after eleven’. Upload a photo in the next step
            """

            steps += [clockTestInstructionStep]
            
            let imageCaptureStep = ORKImageCaptureStep(identifier: "ImageCaptureStep") // we should add a circle template image here
            if let image = UIImage(named: "circle") {
                imageCaptureStep.templateImage = image
            }
            imageCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1)
            steps += [imageCaptureStep]
            
            // Question 2
            let q2Choices = [
                ORKTextChoice(text: "0", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "1-2", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: ">2", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q2ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q2Choices)
            let q2Step = ORKQuestionStep(
                identifier: "q2",
                title: "",
                question: "In the past year, how many times have you been admitted to a hospital?",
                answer: q2ChoiceAnswerFormat
            )
            q2Step.isOptional = false
            
            steps += [q2Step]
            
            // Question 3
            let q3Choices = [
                ORKTextChoice(text: "Excellent", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Very Good", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Good", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Fair", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Poor", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q3ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q3Choices)
            let q3Step = ORKQuestionStep(
                identifier: "q3",
                title: "",
                question: "In general, how would you describe your health?",
                answer: q3ChoiceAnswerFormat
            )
            q3Step.isOptional = false
            
            steps += [q3Step]
            
            // Question 4
            let q4Choices = [
                ORKTextChoice(text: "0-1", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "2-4", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "5-8", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q4ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q4Choices)
            let q4Step = ORKQuestionStep(
                identifier: "q4",
                title: "",
                question: """
                    With how many of the following activities do you require help? (meal preparation, shopping, transportation, telephone,
                    housekeeping, laundry, managing money, taking medications)
                    """,
                answer: q4ChoiceAnswerFormat
            )
            q4Step.isOptional = false
            
            steps += [q4Step]

            // Question 5
            let q5Choices = [
                ORKTextChoice(text: "Always", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Sometimes", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Never", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q5ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q5Choices)
            let q5Step = ORKQuestionStep(
                identifier: "q5",
                title: "",
                question: "When you need help, can you count on someone who is willing and able to meet your needs?",
                answer: q5ChoiceAnswerFormat
            )
            q5Step.isOptional = false
            
            steps += [q5Step]
            
            // Question 6-10
            let q6to10Choices = [
                ORKTextChoice(text: "Yes", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "No", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q6to10ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q6to10Choices)
            let questions = [
                "Do you use five or more different prescription medications on a regular basis?",
                "At times, do you forget to take your prescription medications?",
                "Have you recently lost weight such that your clothing has become looser?",
                "Do you often feel sad or depressed?",
                "Do you have a problem with losing control of urine when you don’t want to?"
            ]
            for (idx, question) in questions.enumerated() {
                let qStep = ORKQuestionStep(
                    identifier: String(format: "Edmonton %d", idx + 6),
                    title: "",
                    question: question,
                    answer: q6to10ChoiceAnswerFormat
                )
                qStep.isOptional = false
                steps += [qStep]
            }
            
            // Get up and Go test step
            let getUpAndGoInstructionStep = ORKInstructionStep(identifier: "getUpAndGo")
            getUpAndGoInstructionStep.title = "Timed Get up and Go Task"
            getUpAndGoInstructionStep.text = """
            Sit in this chair with your back and arms resting. Then, when I say ‘GO’, please
            stand up and walk at a safe and comfortable pace to the mark on the floor (approximately 3m away), return to the
            chair and sit down
                                
            When you're ready to start, click Next
            """

            steps += [getUpAndGoInstructionStep]
            
            let countdownStep = ORKCountdownStep(identifier: "countdown")
            steps += [countdownStep]
                        
            // https://github.com/ResearchKit/ResearchKit/issues/785
            
            func ifitnessActiveStep() -> ORKStep {
                    let step = ORKFitnessStep(identifier: "getupAndGo")
                    step.stepDuration = 60
                    step.title = "Get up and Go Task"
                    step.text = "Short instruction here"
                    step.spokenInstruction = "Instruction. text to speech"
                    step.isOptional = false

                    step.shouldShowDefaultTimer = false

                    step.shouldUseNextAsSkipButton = true
                    step.shouldStartTimerAutomatically = true

                    step.shouldPlaySoundOnStart = true
                    step.shouldVibrateOnStart = true

                    step.shouldVibrateOnFinish = true
                    step.shouldPlaySoundOnFinish = true
                    step.shouldContinueOnFinish = false

                    var recorderConfigurations: [ORKRecorderConfiguration] = []
                    recorderConfigurations.append(ORKPedometerRecorderConfiguration(identifier: "getupAndGo-pedometer"))
                    // recorderConfigurations.append(ORKHealthQuantityTypeRecorderConfiguration(identifier: ORKHeartRateRecorderIdentifier, healthQuantityType: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!, unit: HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())))
                    recorderConfigurations.append(ORKAccelerometerRecorderConfiguration(identifier: "getupAndGo-accelerometer", frequency: 100))
                    recorderConfigurations.append(ORKDeviceMotionRecorderConfiguration(identifier: "getupAndGo-deviceMotion", frequency: 100))
                    step.recorderConfigurations = recorderConfigurations
                    return step
            }
            
            let fitnessStep = ifitnessActiveStep()
            steps += [fitnessStep]
            
            // Question 11
            let q11Choices = [
                ORKTextChoice(text: "0-10 seconds", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "11-20 seconds", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: ">20 seconds", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                ORKTextChoice(text: "Could not complete", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
            ]
            let q11ChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q11Choices)
            let q11Step = ORKQuestionStep(
                identifier: "q11",
                title: "",
                question: "How long (approximately) did it take you?",
                answer: q11ChoiceAnswerFormat
            )
            q11Step.isOptional = false
            
            steps += [q11Step]
            
            // SUMMARY
            let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
            summaryStep.title = "Thank you."
            summaryStep.text = "We appreciate your time."
            
            steps += [summaryStep]
            
            return ORKOrderedTask(identifier: "SurveyTask-Assessment", steps: steps)
        }()
        
        let taskViewController = ORKTaskViewController(task: edmontonSurveyTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // & present the VC!
        return taskViewController
    }
}
