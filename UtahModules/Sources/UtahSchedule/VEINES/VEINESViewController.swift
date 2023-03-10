//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable type_body_length
// swiftlint:disable line_length

import ResearchKit
import SwiftUI
import UIKit

struct VEINESViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    
    func makeCoordinator() -> VEINESViewCoordinator {
        VEINESViewCoordinator()
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(
            task: VEINESTask.createVeinesTask(),
            taskRun: nil
        )
        taskViewController.delegate = context.coordinator
        
        // & present the VC!
        return taskViewController
    }
}
