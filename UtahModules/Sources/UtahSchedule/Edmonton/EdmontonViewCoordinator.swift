//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable lower_acl_than_parent

import Foundation
import ResearchKit

class EdmontonViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    // called when the survey is completed, need to figure out how to upload data to firestore
    public func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?
    ) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
