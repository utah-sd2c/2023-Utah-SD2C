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
            ORKOrderedTask.fitnessCheck(
                withIdentifier: "6 minute walk test",
                intendedUseDescription: "6 minute walk test",
                walkDuration: 360,
                restDuration: 30,
                options: .excludeConclusion
            )
//            ORKOrderedTask.sixMinuteWalk( // TODO: This one is specificly a 6 minute walk test. Should we be using it instead?
//                withIdentifier: "6 minute walk test",
//                intendedUseDescription: "6 minute walk test",
//                //walkDuration: 360,
//                //restDuration: 30,
//                options: .excludeConclusion
//            )
//
//            ORKOrderedTask.timedWalk(
//                withIdentifier: "Get up and Go Task",
//                intendedUseDescription: nil,
//                distanceInMeters: 3,
//                timeLimit: 30,
//                turnAroundTimeLimit: 20,
//                includeAssistiveDeviceForm: false,
//                options: .excludeConclusion
//            )
//            ORKOrderedTask.shortWalk(
//                withIdentifier: "test",
//                intendedUseDescription: nil,
//                numberOfStepsPerLeg: 30,
//                restDuration: 15,
//                options: .excludeLocation
//            )
        }()
        let taskViewController = ORKTaskViewController(task: timedWalkTask, taskRun: nil)
        taskViewController.delegate = context.coordinator
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
        
        // & present the VC!
        return taskViewController
    }
}
