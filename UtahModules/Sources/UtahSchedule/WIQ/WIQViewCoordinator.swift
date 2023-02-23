//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable lower_acl_than_parent
import Firebase
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

            // Add a patient identifier to the response so we know who did this survey
            fhirResponses.subject = Reference(reference: FHIRPrimitive(FHIRString("Patient/PATIENT_ID")))

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
