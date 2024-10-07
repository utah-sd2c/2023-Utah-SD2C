//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable lower_acl_than_parent
// swiftlint:disable function_body_length
// swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable line_length

import Firebase
import FirebaseAuth
import FirebaseStorage
import Foundation
import ModelsR4
import ResearchKit
import SwiftUI
import UtahSharedContext


class EdmontonWIQAndVEINESViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    let firestoreManager: FirestoreManager
    
    init(firestoreManager: FirestoreManager) {
        self.firestoreManager = firestoreManager
    }
    
    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?
    ) {
        switch reason {
        case .completed:
            // Convert the responses into a FHIR object using ResearchKitOnFHIR
            let edmontonResponse = taskViewController.result.fhirResponse
            let wiqResponse = taskViewController.result.fhirResponse
            let veinesResponse = taskViewController.result.fhirResponse
            
            // Separate the Surveys for storage/scoring
            
            // Edmonton Upload
            // Remove the 14 WIQ and 26 VEINES questions
            edmontonResponse.item?.removeLast(40)
            // remove instruction step from fhir
            let instructionStepIndex = edmontonResponse.item!.endIndex - 2
            edmontonResponse.item?.remove(at: instructionStepIndex)
            
            let getUpGoResult = taskViewController.result.stepResult(forStepIdentifier: "Edmonton 11")
            let getUpResult: TimedWalkStepResult = getUpGoResult?.results?[0] as! TimedWalkStepResult
            // get GetUpAndGo score from custom step, put into response
            let strScore = String(getUpResult.score!)
            let getUp = QuestionnaireResponseItemAnswer()
            getUp.value = .string(strScore.asFHIRStringPrimitive())
            edmontonResponse.item?.last?.answer?.removeAll()
            edmontonResponse.item?.last?.answer?.append(getUp)
            let edmontonScore = QuestionnaireUtil.uploadQuestionnaire(fhirResponse: edmontonResponse, firebaseCollection: "edmontonsurveys", surveyType: "edmonton")
            
            
            // WIQ Upload
            // Remove the first 12 (Edmonton) and last 26 (VEINES) questions
            wiqResponse.item?.removeFirst(12)
            wiqResponse.item?.removeLast(26)
            
            _ = QuestionnaireUtil.uploadQuestionnaire(fhirResponse: wiqResponse, firebaseCollection: "wiqsurveys", surveyType: "wiq")
            
            // VEINES Upload
            // Remove the 12 Edmonton and 14 WIQ questions
            veinesResponse.item?.removeFirst(26)
            _ = QuestionnaireUtil.uploadQuestionnaire(fhirResponse: veinesResponse, firebaseCollection: "veinessurveys", surveyType: "veines")

            // updates trends tab
            firestoreManager.fetchAll()
            // We're done with the Edmonton survey, now we will launch
            // the summary page with the score
            if edmontonScore != nil {
                let healthCategories = ["Healthy", "Vulnerable", "Frail"]
                var category = healthCategories[0]
                if edmontonScore! > 10 {
                    category = healthCategories[2]
                } else if edmontonScore! > 5 {
                    category = healthCategories[1]
                }
                
                var summaryViewController: UIViewController?
                let delegate = SheetDismisserProtocol()
                let questionnaireSummaryView = QuestionnaireSummary( delegate: delegate, userScore: Double(edmontonScore!), minScore: 0, maxScore: 15, healthCategory: category)
                summaryViewController = UIHostingController(rootView: AnyView(questionnaireSummaryView))
                delegate.host = (summaryViewController as! UIHostingController<AnyView>)
                
                // Close the current survey and open up the next survey
                weak var presentingViewController = taskViewController.presentingViewController
                taskViewController.dismiss(animated: false, completion: {
                    if let summaryViewController {
                        presentingViewController?.present(
                            summaryViewController,
                            animated: true,
                            completion: nil
                        )
                    }
                })
            }
        default:
            break
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
