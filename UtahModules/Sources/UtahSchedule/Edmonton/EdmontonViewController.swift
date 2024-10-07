//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
// swiftlint:disable line_length
// swiftlint:disable object_literal
// swiftlint:disable force_unwrapping

import Foundation
import ResearchKit
import SwiftUI
import UIKit
import UtahSharedContext

struct EdmontonViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = ORKTaskViewController
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    func makeCoordinator() -> ORKTaskViewControllerDelegate {
        let defaults = UserDefaults.standard
        if let disease = defaults.string(forKey: "disease") {
            switch disease {
            case StorageKeys.conditions[0]:
                return EdmontonWIQViewCoordinator(firestoreManager: firestoreManager)
            case StorageKeys.conditions[1]:
                return EdmontonWIQAndVEINESViewCoordinator(firestoreManager: firestoreManager)
            case StorageKeys.conditions[2]:
                return EdmontonWIQAndVEINESViewCoordinator(firestoreManager: firestoreManager)
            default:
                return EdmontonViewCoordinator(firestoreManager: firestoreManager)
            }
        }
        return EdmontonViewCoordinator(firestoreManager: firestoreManager)
    }
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let taskViewController = ORKTaskViewController(
            task: EdmontonTask.createEdmontonTask(),
            taskRun: nil
        )
        taskViewController.delegate = context.coordinator
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // & present the VC!
        return taskViewController
    }
}
