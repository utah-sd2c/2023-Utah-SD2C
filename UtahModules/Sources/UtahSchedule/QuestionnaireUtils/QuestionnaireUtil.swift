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

public enum QuestionnaireUtil {
    public static func addWIQSteps(steps: inout [ORKStep]) {
        let wiqChoices = [
            ORKTextChoice(text: "No Difficulty", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Slight Difficulty", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Some Difficulty", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Much Difficulty", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Unable to Do", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let wiqAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: wiqChoices)

        let questionsWIQ = [
            "Walk indoors, such as around your home?",
            "Walk 50 feet?",
            "Walk 150 feet? (1/2 block)",
            "Walk 300 feet? 1 block?",
            "Walk 600 feet? 2 blocks?",
            "Walk 900 feet? 3 blocks?",
            "Walk 1500 feet? 5 blocks?"
        ]
        for (idx, question) in questionsWIQ.enumerated() {
            let wiq = ORKQuestionStep(
                identifier: String(format: "WIQ %d", idx + 1),
                title: "How difficult was it for you to:",
                question: question,
                answer: wiqAnswerFormat
            )
            wiq.isOptional = false
            steps += [wiq]
        }
    }
    
    public static func addVEINESSteps(steps: inout [ORKStep]) {
        // Question 1
        let q1Choices = [
            ORKTextChoice(text: "Every day", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Several times a week", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "About once a week", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Less than once a week", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Never", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q1AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q1Choices)
        let q1a = ORKFormItem(identifier: "VEINES 1a", text: "Heavy legs", answerFormat: q1AnswerFormat)
        let q1b = ORKFormItem(identifier: "VEINES 1b", text: "Aching legs", answerFormat: q1AnswerFormat)
        let q1c = ORKFormItem(identifier: "VEINES 1c", text: "Swelling", answerFormat: q1AnswerFormat)
        let q1d = ORKFormItem(identifier: "VEINES 1d", text: "Night cramps", answerFormat: q1AnswerFormat)
        let q1e = ORKFormItem(identifier: "VEINES 1e", text: "Heat or burning sensation", answerFormat: q1AnswerFormat)
        let q1f = ORKFormItem(identifier: "VEINES 1f", text: "Restless legs", answerFormat: q1AnswerFormat)
        let q1g = ORKFormItem(identifier: "VEINES 1g", text: "Throbbing", answerFormat: q1AnswerFormat)
        let q1h = ORKFormItem(identifier: "VEINES 1h", text: "Itching", answerFormat: q1AnswerFormat)
        let q1i = ORKFormItem(identifier: "VEINES 1i", text: "Tingling sensation (e.g.pins and needles)", answerFormat: q1AnswerFormat)

        let q1Step = ORKFormStep(
            identifier: "VEINES 1",
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
        let q2ChoicesV = [
            ORKTextChoice(text: "On walking", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "At mid-day", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "At the end of the day", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "During the night", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "At any time of the day", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Never", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q2AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q2ChoicesV)
        let q2StepV = ORKQuestionStep(
            identifier: "VEINES 2",
            title: "",
            question: """
                        At what time of the day is your leg problem most instense?
                        """,
            answer: q2AnswerFormat
        )
        q2StepV.isOptional = false

        steps += [q2StepV]

        // Question 3
        let q3ChoicesV = [
            ORKTextChoice(text: "Much better now than one year ago", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Somewhat better now than one year ago", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "About the same now as one year ago", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Somewhat worse now than one year ago", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Much worse now than one year ago", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "I did not have any leg problems last year", value: "6" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q3AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q3ChoicesV)
        let q3StepV = ORKQuestionStep(
            identifier: "VEINES 3",
            title: "",
            question: """
                        Compared to one year ago, how would you rate your leg problem in general now?
                        """,
            answer: q3AnswerFormat
        )
        q3StepV.isOptional = false

        steps += [q3StepV]

        // Question 4
        let q4ChoicesV = [
            ORKTextChoice(text: "N/A", value: "0" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "YES, limited a lot", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "YES, limited a little", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "NO, not limited at all", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q4AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q4ChoicesV)
        let q4a = ORKFormItem(
            identifier: "VEINES 4a",
            text: "Daily activities at work",
            answerFormat: q4AnswerFormat
        )
        let q4b = ORKFormItem(
            identifier: "VEINES 4b",
            text: "Daily activities at home (e.g. housework, ironing, doing odd jobs repairs around the house, gardening, etc...)",
            answerFormat: q4AnswerFormat
        )
        let q4c = ORKFormItem(
            identifier: "VEINES 4c",
            text: "Social or leisure activities in which you are standing for long periods (e.g. parties, weddings, taking public transportation, shopping, etc...)",
            answerFormat: q4AnswerFormat
        )
        let q4d = ORKFormItem(
            identifier: "VEINES 4d",
            text: "Social or leisure activities in which you are sitting for long periods (e.g. going to the cinema or the theater, travelling, etc...)",
            answerFormat: q4AnswerFormat
        )
        let q4StepV = ORKFormStep(
            identifier: "VEINES 4",
            title: "",
            text:
                        """
                        The following items are about activities that you might do in a typical day. Does your leg problem now limit you
                        in these activities? If so, how much ?
                        """
        )
        q4StepV.formItems = [q4a, q4b, q4c, q4d]
        q4StepV.isOptional = false
        steps += [q4StepV]

        // Question 5
        let q5ChoicesV = [
            ORKTextChoice(text: "YES", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "NO", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q5AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q5ChoicesV)
        let q5a = ORKFormItem(
            identifier: "VEINES 5a",
            text: "Cut down the amount of time you spent on work or other activities",
            answerFormat: q5AnswerFormat
        )
        let q5b = ORKFormItem(
            identifier: "VEINES 5b",
            text: "Accomplished less than you would like",
            answerFormat: q5AnswerFormat
        )
        let q5c = ORKFormItem(
            identifier: "VEINES 5c",
            text: "Were limited in the kind of work or other activities",
            answerFormat: q5AnswerFormat
        )
        let q5d = ORKFormItem(
            identifier: "VEINES 5d",
            text: "Had difficulty performing the work or other activities (for example, it took extra effort)",
            answerFormat: q5AnswerFormat
        )
        let q5StepV = ORKFormStep(
            identifier: "VEINES 5",
            title: "",
            text:
                        """
                        During the past 4 weeks, have you had any of the following probloems with your work or other
                        regular daily activities as a result of your leg problem?
                        """
        )
        q5StepV.formItems = [q5a, q5b, q5c, q5d]
        q5StepV.isOptional = false
        steps += [q5StepV]

        // Question 6
        let q6ChoicesV = [
            ORKTextChoice(text: "Not at all", value: "1" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Slightly", value: "2" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Moderately", value: "3" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Quite a bit", value: "4" as NSSecureCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Extremely", value: "5" as NSSecureCoding & NSCopying & NSObjectProtocol)
        ]

        let q6AnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: q6ChoicesV)
        let q6StepV = ORKQuestionStep(
            identifier: "VEINES 6",
            title: "",
            question: """
                        During the past 4 weeks, to what extent has your leg problem interfered with your normal social activities
                        with family, friends, neighbors or groups?
                        """,
            answer: q6AnswerFormat
        )
        q6StepV.isOptional = false

        steps += [q6StepV]

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
            identifier: "VEINES 7",
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
            identifier: "VEINES 8a",
            text: "Have you felt concerned about the appearance of your leg(s)?",
            answerFormat: q8AnswerFormat
        )
        let q8b = ORKFormItem(
            identifier: "VEINES 8b",
            text: "Have you felt ittitable?",
            answerFormat: q8AnswerFormat
        )
        let q8c = ORKFormItem(
            identifier: "VEINES 8c",
            text: "Have you felt a burden to your family or friends?",
            answerFormat: q8AnswerFormat
        )
        let q8d = ORKFormItem(
            identifier: "VEINES 8d",
            text: "Have you been worried about bumping into things?",
            answerFormat: q8AnswerFormat
        )
        let q8e = ORKFormItem(
            identifier: "VEINES 8e",
            text: "Has the appearance of your leg(s) influenced your choice of clothing?",
            answerFormat: q8AnswerFormat
        )
        let q8Step = ORKFormStep(
            identifier: "VEINES 8",
            title: "",
            text:
                        """
                        How much of the time during the past 4 weeks:
                        """
        )
        q8Step.formItems = [q8a, q8b, q8c, q8d, q8e]
        q8Step.isOptional = false
        steps += [q8Step]
    }
    
    public static func addEdmontonSteps(steps: inout [ORKStep]) {
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Patient Questionnaire"
        instructionStep.text = """
        This information will help your doctors keep track of how you feel and how well you are able to do your usual activities. If you are unsure about how to answer a question, please give the best answer you can.

        You will be asked to complete this questionnaire at regular intervals to track your progress over time. You will be able to view your progress in the trends tab.
        """

        steps += [instructionStep]

        // Clock test step
        let clockTestInstructionStep = ORKInstructionStep(identifier: "ClockStep")
        clockTestInstructionStep.title = "Draw a clock"
        clockTestInstructionStep.text = """
        First, we would like you to get out a piece of paper and something to write with.

        Now, we want you to draw a clock.
         (1) Draw a circle
         (2) Put in all of the numbers where they go
         (3) Set the hands of the clock to 10 after 11

        When you are finished, upload a photo of your clock in the next step.

        """

        steps += [clockTestInstructionStep]

        let imageCaptureStep = ORKImageCaptureStep(identifier: "Edmonton 1") // we should add a circle template image here
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
            identifier: "Edmonton 2",
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
            identifier: "Edmonton 3",
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
            identifier: "Edmonton 4",
            title: "",
            question: """
                With how many of the following activities do you require help? (meal preparation, shopping, transportation, telephone, housekeeping, laundry, managing money, taking medications)
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
            identifier: "Edmonton 5",
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

        // Walk
        // Instruction step
        let getUpIntroStep = ORKInstructionStep(identifier: "GetUpAndGoIntro")
        getUpIntroStep.title = "Get Up and Go"
        getUpIntroStep.text = """
        We would like you to perform a walking test

        Instructions:
        Sit in a chair with your back and arms resting. Please stand from your seated position and walk at a safe and comfortable pace approximately 3 meters away. Then, click the ‘STOP’ button on the phone.

        If you are unable to perform this test safely please have someone help you or click the STOP button immediately.


        Click Next to see a demonstration.
        """

        steps += [getUpIntroStep]
        
        let videoStep = ORKVideoInstructionStep(identifier: "VideoInstructionStep")
        videoStep.videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/cs342-2023-utah.appspot.com/o/video.mp4?alt=media&token=121045b0-f9d2-49eb-86c2-bf0425141d7e")
        videoStep.title = "Demonstration Above"
        videoStep.text = """
        Click to Play
        
        When you're ready to start, click Next.
        """

        steps += [videoStep]

        let q11Step = TimedWalkStep(identifier: "Edmonton 11")
        q11Step.isOptional = false

        steps += [q11Step]
    }
    
    static func uploadQuestionnaire(
        fhirResponse: QuestionnaireResponse,
        firebaseCollection: String,
        surveyType: String
    ) {
        var score = 0
        // calculating score
        if let responseItems = fhirResponse.item {
            for item in responseItems {
                if let stringscor = item.answer?[0] {
                    do {
                        let encod = JSONEncoder()
                        let ifh = try encod.encode(stringscor)
                        
                        let json = String(decoding: ifh, as: UTF8.self)
                        if json.contains("valueString") {
                            score += json[json.index(json.startIndex, offsetBy: 16)].wholeNumberValue!
                        }
                    } catch {
                        print(error.localizedDescription, " Error when calculating score.")
                    }
                }
            }
        }

        let user = Auth.auth().currentUser
        // Add a patient identifier to the response so we know who did this survey
        fhirResponse.subject = Reference(reference: FHIRPrimitive(FHIRString("Patient/" + (user?.uid ?? "PATIENT_ID"))))
        fhirResponse.questionnaire = surveyType.asFHIRCanonicalPrimitive()

        do {
            // Parse the FHIR object into JSON
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(fhirResponse)

            // Print out the JSON for debugging
            let json = String(decoding: data, as: UTF8.self)
            print(json)

            // Convert the FHIR object to a dictionary and upload to Firebase
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let identifier = fhirResponse.id?.value?.string ?? UUID().uuidString

            guard let jsonDict else {
                return
            }

            let database = Firestore.firestore()
            database.collection(firebaseCollection).document(identifier).setData(jsonDict) { err in
                if let err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written.")
                }
            }


            // Upload Score + Data to user collection
            let userQuestionnaireData = ["score": score, "type": surveyType, "surveyId": identifier, "dateCompleted": Timestamp()] as [String: Any]
            let userUID = user?.uid
            if userUID != nil {
                database.collection("users").document(userUID!).collection("QuestionnaireResponse").document(identifier).setData(userQuestionnaireData) { err in
                    if let err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written.")
                    }
                }
            }
            
            // only survey with storage necessary
            if surveyType == "edmonton" {
                // Upload any files that are attached to the FHIR object to Firebase
                if let responseItems = fhirResponse.item {
                    for item in responseItems {
                        if case let .attachment(value) = item.answer?.first?.value {
                            guard let fileURL = value.url?.value?.url else {
                                continue
                            }
                            
                            // Get a reference to the Cloud Storage service
                            let storageRef = Storage.storage().reference()
                            
                            // Create a reference for the new file
                            // and put it in the "edmonton" file on Cloud Storage
                            let fileName = fileURL.lastPathComponent
                            let fileRef = storageRef.child("edmonton/" + fileName)
                            
                            // Upload the file to Cloud Storage using the reference
                            fileRef.putFile(from: fileURL, metadata: nil) { _, error in
                                if let error {
                                    print("An error occurred: \(error)")
                                } else {
                                    print("\(fileName) was uploaded successfully!")
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            // Something didn't work!
            print(error.localizedDescription)
        }
    }
}
