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


class SixMinuteWalkViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
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
            // Collect data from the ActiveStep
            let sixMinuteWalkTestResult = taskViewController.result.stepResult(forStepIdentifier: SixMinuteWalkTestUtil.activeStepIdentifier)
            let sixMWTResults = sixMinuteWalkTestResult!.results as? [SixMinuteWalkStepResult]
            // And upload it to Firebase
            SixMinuteWalkTestUtil.uploadSixMinuteWalkTest(sixMinuteWalkStepResults: sixMWTResults!)
        
            // If we want a screen to display the result data, we can modify this (copied from QuestionnaireUtil)
            // updates trends tab
            //firestoreManager.fetchAll()
            // We're done with the Edmonton survey, now we will launch
            // the summary page with the score
            //if edmontonScore != nil {
            //    let healthCategories = ["Healthy", "Vulnerable", "Frail"]
            //    var category = healthCategories[0]
            //    if edmontonScore! > 10 {
            //        category = healthCategories[2]
            //    } else if edmontonScore! > 5 {
            //        category = healthCategories[1]
            //    }
            //
            //    var summaryViewController: UIViewController?
            //    let delegate = SheetDismisserProtocol()
            //    let questionnaireSummaryView = QuestionnaireSummary( delegate: delegate, userScore: Double(edmontonScore!), minScore: 0, maxScore: 15, healthCategory: category)
            //    summaryViewController = UIHostingController(rootView: AnyView(questionnaireSummaryView))
            //    delegate.host = (summaryViewController as! UIHostingController<AnyView>)
                
                // Close the current survey and open up the next survey
            //    weak var presentingViewController = taskViewController.presentingViewController
            //    taskViewController.dismiss(animated: false, completion: {
            //        if let summaryViewController {
            //            presentingViewController?.present(
            //                summaryViewController,
            //                animated: true,
            //                completion: nil
            //            )
            //        }
            //    })
            //}
        default:
            break
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
