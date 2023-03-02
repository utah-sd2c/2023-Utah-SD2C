//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable type_body_length
// swiftlint:disable line_length

import ResearchKit
import SwiftUI
import UIKit

struct VEINESViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> VEINESViewCoordinator {
        VEINESViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let wiqSurveyTask: ORKOrderedTask = {
            var steps = [ORKStep]()
            
            let instruction = ORKInstructionStep(identifier: "VEINES")
                    instruction.title = "VEINES-QOL/Sym Questionnaire"
                    instruction.text = """
                        This information will help your doctors keep track of how you feel and how well you are able to do your usual activities. If you are unsure about how to answer a question, please give the best answer you can.
                        
                        You will be asked to complete this questionnaire at regular intervals to track your progress over time. You will be able to view your progress in the trends tab.

                        """
                    
                    steps += [instruction]
            
                    // Question 1
                    let q1Choices = [
                        ORKTextChoice(text: "Every day", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Several times a week", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "About once a week", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Less than once a week", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Never", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q1AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q1Choices)
                    let q1a = ORKFormItem(identifier: "q1a", text: "Heavy legs", answerFormat: q1AnswerFormat)
                    let q1b = ORKFormItem(identifier: "q1b", text: "Aching legs", answerFormat: q1AnswerFormat)
                    let q1c = ORKFormItem(identifier: "q1c", text: "Swelling", answerFormat: q1AnswerFormat)
                    let q1d = ORKFormItem(identifier: "q1d", text: "Night cramps", answerFormat: q1AnswerFormat)
                    let q1e = ORKFormItem(identifier: "q1e", text: "Heat or burning sensation", answerFormat: q1AnswerFormat)
                    let q1f = ORKFormItem(identifier: "q1f", text: "Restless legs", answerFormat: q1AnswerFormat)
                    let q1g = ORKFormItem(identifier: "q1g", text: "Throbbing", answerFormat: q1AnswerFormat)
                    let q1h = ORKFormItem(identifier: "q1h", text: "Itching", answerFormat: q1AnswerFormat)
                    let q1i = ORKFormItem(identifier: "q1i", text: "Tingling sensation (e.g.pins and needles)", answerFormat: q1AnswerFormat)

                    let q1Step = ORKFormStep(
                        identifier: "q1",
                        title: "",
                        text:
                            """
                            During the past 4 weeks, how often have you had any of the following leg problems?
                            """
                    )
                    q1Step.formItems = [q1a, q1b, q1c, q1d, q1e, q1f, q1g, q1h, q1i]
                    q1Step.isOptional = false
                    steps += [q1Step]

                    // Question 2
                    let q2Choices = [
                        ORKTextChoice(text: "On walking", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "At mid-day", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "At the end of the day", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "During the night", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "At any time of the day", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Never", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q2AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q2Choices)
                    let q2Step = ORKQuestionStep(
                        identifier: "q2",
                        title: "",
                        question: """
                            At what time of the day is your leg problem most instense?
                            """,
                        answer: q2AnswerFormat
                    )
                    q2Step.isOptional = false
                    
                    steps += [q2Step]
            
                    // Question 3
                    let q3Choices = [
                        ORKTextChoice(text: "Much better now than one year ago", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Somewhat better now than one year ago", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "About the same now as one year ago", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Somewhat worse now than one year ago", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Much worse now than one year ago", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "I did not have any leg problem last year", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q3AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q3Choices)
                    let q3Step = ORKQuestionStep(
                        identifier: "q3",
                        title: "",
                        question: """
                            Compared to one year ago, how would you rate your leg problem in general now?
                            """,
                        answer: q3AnswerFormat
                    )
                    q3Step.isOptional = false
                    
                    steps += [q3Step]
            
                    // Question 4
                    let q4Choices = [
                        ORKTextChoice(text: "N/A", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "YES, limited a lot", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "YES, limited a little", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "NO, not limited at all", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q4AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q4Choices)
                    let q4a = ORKFormItem(
                        identifier: "q4a",
                        text: "Daily activities at work",
                        answerFormat: q4AnswerFormat
                    )
                    let q4b = ORKFormItem(
                        identifier: "q4b",
                        text: "Daily activities at home (e.g. housework, ironing, doing odd jobs repairs around the house, gardening, etc...)",
                        answerFormat: q4AnswerFormat
                    )
                    let q4c = ORKFormItem(
                        identifier: "q4c",
                        text: "Social or leisure activities in which you are standing for long periods (e.g. parties, weddings, taking public transportation, shopping, etc...)",
                        answerFormat: q4AnswerFormat
                    )
                    let q4d = ORKFormItem(
                        identifier: "q4d",
                        text: "Social or leisure activities in which you are sitting for long periods (e.g. going to the cinema or the theater, travelling, etc...)",
                        answerFormat: q4AnswerFormat
                    )
                    let q4Step = ORKFormStep(
                        identifier: "q4",
                        title: "",
                        text:
                            """
                            The following items are about activities that you might do in a typical day. Does your leg problem now limit you
                            in these activities? If so, how much ?
                            """
                    )
                    q4Step.formItems = [q4a, q4b, q4c, q4d]
                    q4Step.isOptional = false
                    steps += [q4Step]
            
                    // Question 5
                    let q5Choices = [
                        ORKTextChoice(text: "YES", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "NO", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q5AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q5Choices)
                    let q5a = ORKFormItem(
                        identifier: "q5a",
                        text: "Cut down the amount of time you spent on work or other activities",
                        answerFormat: q5AnswerFormat
                    )
                    let q5b = ORKFormItem(
                        identifier: "q5b",
                        text: "Accomplished less than you would like",
                        answerFormat: q5AnswerFormat
                    )
                    let q5c = ORKFormItem(
                        identifier: "q5c",
                        text: "Were limited in the kind of work or other activities",
                        answerFormat: q5AnswerFormat
                    )
                    let q5d = ORKFormItem(
                        identifier: "q5d",
                        text: "Had difficulty performing the work or other activities (for example, it took extra effort)",
                        answerFormat: q5AnswerFormat
                    )
                    let q5Step = ORKFormStep(
                        identifier: "q5",
                        title: "",
                        text:
                            """
                            During the past 4 weeks, have you has any of the following probloems with your work or other
                            regular daily activities as a result of your leg problem?
                            """
                    )
                    q5Step.formItems = [q5a, q5b, q5c, q5d]
                    q5Step.isOptional = false
                    steps += [q5Step]
            
                    // Question 6
                    let q6Choices = [
                        ORKTextChoice(text: "Not at all", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Slightly", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Moderately", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Quite a bit", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Extremely", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q6AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q6Choices)
                    let q6Step = ORKQuestionStep(
                        identifier: "q6",
                        title: "",
                        question: """
                            During the past 4 weeks, to what extent has your leg problem interfered with your normal social activities
                            with family, friends, neighbors or groups?
                            """,
                        answer: q6AnswerFormat
                    )
                    q6Step.isOptional = false
                    
                    steps += [q6Step]
            
                    // Question 7
                    let q7Choices = [
                        ORKTextChoice(text: "None", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Very mild", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Mild", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Moderate", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Severe", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Very severe", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q7AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q7Choices)
                    let q7Step = ORKQuestionStep(
                        identifier: "q7",
                        title: "",
                        question: """
                            How much leg pain have your had during the past 4 weeks?
                            """,
                        answer: q7AnswerFormat
                    )
                    q7Step.isOptional = false
                    
                    steps += [q7Step]
            
                    // Question 8
                    let q8Choices = [
                        ORKTextChoice(text: "All of the time", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Most of the time", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "A good bit of the time", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "Some of the time", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "A little of the time", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
                        ORKTextChoice(text: "None of the time", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
                    ]
                    
                    let q8AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q8Choices)
                    let q8a = ORKFormItem(
                        identifier: "q8a",
                        text: "Have you felt concerned about the appearance of your leg(s)?",
                        answerFormat: q8AnswerFormat
                    )
                    let q8b = ORKFormItem(
                        identifier: "q8b",
                        text: "Have you felt ittitable?",
                        answerFormat: q8AnswerFormat
                    )
                    let q8c = ORKFormItem(
                        identifier: "q8c",
                        text: "Have you felt a burden to your family or friends?",
                        answerFormat: q8AnswerFormat
                    )
                    let q8d = ORKFormItem(
                        identifier: "q8d",
                        text: "Have you been worried about bumping into things?",
                        answerFormat: q8AnswerFormat
                    )
                    let q8e = ORKFormItem(
                        identifier: "q8e",
                        text: "Has the appearance of your leg(s) influenced your choice of clothing?",
                        answerFormat: q8AnswerFormat
                    )
                    let q8Step = ORKFormStep(
                        identifier: "q8",
                        title: "",
                        text:
                            """
                            How much of the time during the past 4 weeks:
                            """
                    )
                    q8Step.formItems = [q8a, q8b, q8c, q8d, q8e]
                    q8Step.isOptional = false
                    steps += [q8Step]
                    
                    // SUMMARY
                    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
                    summaryStep.title = "Thank you."
                    summaryStep.text = "You can view your progress in the trends tab."
                    steps += [summaryStep]
                    
                    return ORKOrderedTask(identifier: "veines", steps: steps)
        }()
        
        let taskViewController = ORKTaskViewController(task: wiqSurveyTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        
        // & present the VC!
        return taskViewController
    }
}
