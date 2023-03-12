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


class EdmontonWIQViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
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
            
            // Separate the Surveys for storage/scoring
            
            // Edmonton Upload
            edmontonResponse.item?.removeLast(7)
            let getUpGoResult = taskViewController.result.stepResult(forStepIdentifier: "Edmonton 11")
            let getUpResult: TimedWalkStepResult = getUpGoResult?.results?[0] as! TimedWalkStepResult
            
                // get GetUpAndGo score from custom step, put into response
            let strScore = String(getUpResult.score!)
            let getUp = QuestionnaireResponseItemAnswer()
            getUp.value = .string(strScore.asFHIRStringPrimitive())
            edmontonResponse.item?.last?.answer?.removeAll()
            edmontonResponse.item?.last?.answer?.append(getUp)
            QuestionnaireUtil.uploadQuestionnaire(fhirResponse: edmontonResponse, firebaseCollection: "edmontonsurveys", surveyType: "edmonton")
            
            // WIQ Upload
            wiqResponse.item?.removeFirst(11)
            QuestionnaireUtil.uploadQuestionnaire(fhirResponse: wiqResponse, firebaseCollection: "wiqsurveys", surveyType: "wiq")
        default:
            break
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
