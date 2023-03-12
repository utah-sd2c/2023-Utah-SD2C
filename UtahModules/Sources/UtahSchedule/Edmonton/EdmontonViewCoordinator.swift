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


class EdmontonViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?
    ) {
        switch reason {
        case .completed:
            // Convert the responses into a FHIR object using ResearchKitOnFHIR
            let fhirResponse = taskViewController.result.fhirResponse
            
            // remove instruction step from fhir
            let instructionStepIndex = fhirResponse.item!.endIndex - 2
            fhirResponse.item?.remove(at: instructionStepIndex)
            
            let getUpGoResult = taskViewController.result.stepResult(forStepIdentifier: "Edmonton 11")
            let getUpResult: TimedWalkStepResult = getUpGoResult?.results?[0] as! TimedWalkStepResult
            
            let strScore = String(getUpResult.score!)
            let getUp = QuestionnaireResponseItemAnswer()
            getUp.value = .string(strScore.asFHIRStringPrimitive())
            fhirResponse.item?.last?.answer?.removeAll()
            fhirResponse.item?.last?.answer?.append(getUp)
            
            QuestionnaireUtil.uploadQuestionnaire(fhirResponse: fhirResponse, firebaseCollection: "edmontonsurveys", surveyType: "edmonton")
        default:
            break
        }
        taskViewController.dismiss(animated: true, completion: nil)
        // We're done with the Edmonton survey, now we will launch
        // a second survey depending on which type of disease the user
        // reported having during onboarding.
        /*
        let defaults = UserDefaults.standard
        if let disease = defaults.string(forKey: "disease") {
            var nextSurveyViewController: UIViewController?

            switch disease {
            case "Arterial Disease":
                // Set the next survey
                nextSurveyViewController = UIHostingController(rootView: WIQViewController())
            case "Venous Disease":
                nextSurveyViewController = UIHostingController(rootView: VEINESViewController())
            default:
                nextSurveyViewController = nil
            }

            // Close the current survey and open up the next survey
            weak var presentingViewController = taskViewController.presentingViewController
            taskViewController.dismiss(animated: true, completion: {
                if let nextSurveyViewController {
                    presentingViewController?.present(
                        nextSurveyViewController,
                        animated: true,
                        completion: nil
                    )
                }
            })
        } else {
            // If the disease lookup fails, end the survey
            taskViewController.dismiss(animated: true, completion: nil)
        }
         */
    }
}
