//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable line_length
// swiftlint:disable closure_body_length

import ResearchKit
import SwiftUI
import UIKit

struct WIQViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> WIQViewCoordinator {
        WIQViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(
            task: WIQTask.createWiqSurveyTask(),
            taskRun: nil
        )
        taskViewController.delegate = context.coordinator
        
        // & present the VC!
        return taskViewController
    }
}
