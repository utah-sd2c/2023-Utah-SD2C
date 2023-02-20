//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ResearchKit
import SwiftUI
import UIKit

struct TimedWalkViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> TimedWalkViewCoordinator {
        TimedWalkViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let timedWalkTask: ORKOrderedTask = {
            ORKOrderedTask.timedWalk(
                withIdentifier: "Get up and Go Task",
                intendedUseDescription: nil,
                distanceInMeters: 3,
                timeLimit: 30,
                turnAroundTimeLimit: 20,
                includeAssistiveDeviceForm: false,
                options: .excludeConclusion
            )
        }()
        let taskViewController = ORKTaskViewController(task: timedWalkTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        
        // & present the VC!
        return taskViewController
    }
}
