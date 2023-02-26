//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FHIR
import HealthKitDataSource
import Onboarding
import SwiftUI
import UtahSharedContext


struct HealthKitPermissions: View {
    @EnvironmentObject var healthKitDataSource: HealthKit<FHIR>
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "HealthKit".moduleLocalized,
                        subtitle: "VascuTrack is asking for read and write access to your Apple HealthKit".moduleLocalized
                    )
                    Spacer()
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    Text("We will ensure your privacy to the highest standard.", bundle: .module)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "HEALTHKIT_PERMISSIONS_BUTTON".moduleLocalized,
                    action: {
                        do {
                            try await healthKitDataSource.askForAuthorization()
                        } catch {
                            print("Could not request HealthKit permissions.")
                        }
                        completedOnboardingFlow = true
                    }
                )
            }
        )
    }
}


struct HealthKitPermissions_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitPermissions()
    }
}
