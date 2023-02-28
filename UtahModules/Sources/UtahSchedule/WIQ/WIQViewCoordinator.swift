//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable lower_acl_than_parent
// swiftlint:disable function_body_length
// swiftlint:disable force_unwrapping
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable line_length

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import ModelsR4
import ResearchKit

class WIQViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    // called when the survey is completed, need to figure out how to upload data to firestore
    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?
    ) {
        switch reason {
        case .completed:
            // Convert the responses into a FHIR object using ResearchKitOnFHIR
            let fhirResponses = taskViewController.result.fhirResponse
            var score = 0
            
            // calculating score
            if let responseItems = fhirResponses.item {
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
            fhirResponses.subject = Reference(reference: FHIRPrimitive(FHIRString("Patient/" + (user?.uid ?? "PATIENT_ID"))))

            do {
                // Parse the FHIR object into JSON
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(fhirResponses)

                // Print out the JSON for debugging
                let json = String(decoding: data, as: UTF8.self)
                print(json)

                // Convert to dictionary and upload to Firebase
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let identifier = fhirResponses.id?.value?.string ?? UUID().uuidString

                guard let jsonDict else {
                    return
                }

                let database = Firestore.firestore()
                database.collection("wiqsurveys").document(identifier).setData(jsonDict) { err in
                    if let err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written.")
                    }
                }
                
                // Upload Score + Data to user collection
                let userQuestionnaireData = ["score": score, "type": "wiq", "surveyId": identifier] as [String: Any]
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
            } catch {
                // Something didn't work!
                print(error.localizedDescription)
            }
        default:
            break
        }

        // We're done, dismiss the survey
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
