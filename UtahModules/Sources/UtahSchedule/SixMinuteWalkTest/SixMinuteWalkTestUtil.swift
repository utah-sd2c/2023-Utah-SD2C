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
    
    public static var activeStepIdentifier = "SixMinuteWalkActiveStep"
    
    public static func addInstructionSteps(steps: inout [ORKStep]) {
        // Instruction steps
        let instructionStep1 = ORKInstructionStep(identifier: "SixMinuteWalkInstructionStep1")
        instructionStep1.title = "6-Minute Walk Test"
        instructionStep1.text = """
        ⚠️ PLEASE DO NOT LOCK YOUR PHONE UNTIL THIS TEST IS COMPLETE
        
        ⏱️ This test will take 6-minutes.
                
        ⌛ Ensure you have 6-minutes of uninterrupted time before starting.
         
         👟 Wear comfortable clothes and properly fitting shoes. If you normally use a walking aid, you can use it while completing this test.
         
         🏠 If you are unable to walk outdoors, consider completing this test at a local shopping mall or location that you can walk back and forth such as a long hallway in your home.
        """

        steps += [instructionStep1]
        
        let instructionStep2 = ORKInstructionStep(identifier: "SixMinuteWalkInstructionStep2")
        instructionStep2.title = "Getting Started"
        instructionStep2.text = """
        1) Find a straight walking path at least 30 meters in length.

        2) Walk as far as you can at a safe pace for six minutes.

        3) Stop and rest as necessary and begin again as soon as you are able. The timer will continue counting down. Press the “Rest” button on the next page every time you stop to rest.

        4) When you are ready to begin, press “Get Started” below
        """

        steps += [instructionStep2]
        
    }
    
    public static func addActiveStep(steps: inout [ORKStep]) {
        
        let activeStep = SixMinuteWalkStep(identifier: activeStepIdentifier)
        activeStep.isOptional = false

        steps += [activeStep]
    }
    
    public static func addCompletionStep(steps: inout [ORKStep]) {
        
        let completionStep = SixMinuteWalkCompletionStep(identifier: "SixMinuteWalkCompletionStep")
        completionStep.isOptional = false
        completionStep.title = "6-Minute Walk Test Complete"
        completionStep.text = "Thank you for completing the 6-Minute Walk Test. Please click Done below."
        
        steps += [completionStep]
    }
    
    static func uploadSixMinuteWalkTest(sixMinuteWalkStepResults: [SixMinuteWalkStepResult]) -> Void {
        var identifier = ""
        var resultDict = [String: [String: Any]]()
        for i in 0..<sixMinuteWalkStepResults.count {
            let entry = sixMinuteWalkStepResults[i]
            // If this is the last result it is the end of step result
            var entryName = "FinalResult"
            // Otherwise it's a Rest button press
            if(i != sixMinuteWalkStepResults.count-1){
                entryName = "RestButtonPressNumber" + String(i+1)
            } else {
                // Set the identifier to be the UTC time of completion
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.dateFormat = "y, MMM d, HH:mm:ss"
                identifier = dateFormatter.string(from: entry.absoluteTime!)
            }
            resultDict[entryName] = ["Steps": entry.steps!, "Distance": entry.distance!, "TimeSinceTestBegan": entry.relativeTime!, "UTCTimeOfSubmission": entry.absoluteTime!]
        }
        
        let user = Auth.auth().currentUser
        do {
            print(resultDict)
            
            //let identifier = UUID().uuidString
            //let identifier = resultDict["FinalResult"]!["UTCTimeOfSubmission"]
            let database = Firestore.firestore()
            
            // Upload results to user collection
            let userUID = user?.uid
            if userUID != nil {
                for entry in resultDict{
                    database.collection("users").document(userUID!).collection("SixMinuteWalkTestResult").document(identifier).setData(["Type": "6MWT"]) { err in
                        if let err {
                            print("Error writing document parent: \(err)")
                        } else {
                            database.collection("users").document(userUID!).collection("SixMinuteWalkTestResult").document(identifier).collection("RestsAndFinish").document(entry.key).setData(resultDict[entry.key]!) { err2 in
                                if let err2 {
                                    print("Error writing document: \(err2)")
                                } else {
                                    print("Document successfully written.")
                                    SwiftUI.Task { await NotificationUtil.SetSixMinuteWalkTestNotifications() }                                }
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

//let userUID = user?.uid
//if userUID != nil {
//    for entry in resultDict {
//        database.collection("users").document(userUID!).collection("SixMinuteWalkTestResult").document(identifier).setData(["Type": "6MWT"]) { err in
//            if let err = err {
//                print("Error writing document parent: \(err)")
//            } else {
//                print("Successfully created parent document with ID: \(identifier)")
//                database.collection("users").document(userUID!).collection("SixMinuteWalkTestResult").document(identifier).collection("RestsAndFinish").document(entry.key).setData(resultDict[entry.key]!) { err2 in
//                    if let err2 = err2 {
//                        print("Error writing document: \(err2)")
//                    } else {
//                        print("Document successfully written.")
//                    }
