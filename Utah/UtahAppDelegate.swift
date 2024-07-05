//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import HealthKit
import Spezi
import SpeziFHIR
import SpeziFHIRToFirestoreAdapter
import SpeziFirebaseAccount
import SpeziFirestore
import SpeziFirestorePrefixUserIdAdapter
import SpeziHealthKit
import SpeziHealthKitToFHIRAdapter
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI
import UtahSchedule
import UtahSharedContext
import class FirebaseFirestore.FirestoreSettings
import class FirebaseFirestore.MemoryCacheSettings


class UtahAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: FHIR()) {
            if !FeatureFlags.disableFirebase {
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099))
                } else {
                    FirebaseAccountConfiguration()
                }
                firestore
            }
            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
            QuestionnaireDataSource()
            UtahScheduler()
        }
    }
    
    
    private var firestore: Firestore<FHIR> {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            adapter: {
                FHIRToFirestoreAdapter()
                FirestorePrefixUserIdAdapter()
            },
            settings: settings
        )
    }
    
    
    private var healthKit: HealthKit<FHIR> {
        HealthKit {
            CollectSample(
                HKQuantityType(.stepCount),
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
            )
            CollectSample(
                HKQuantityType(.distanceWalkingRunning),
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
                        )        } adapter: {
            HealthKitToFHIRAdapter()
        }
    }
}
