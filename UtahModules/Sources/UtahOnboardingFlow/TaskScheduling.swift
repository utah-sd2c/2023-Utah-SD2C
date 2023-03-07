//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Onboarding
import Scheduler
import SwiftUI
import UserNotifications
import UtahSchedule
import UtahSharedContext


struct TaskScheduling: View {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @EnvironmentObject var scheduler: UtahScheduler


    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "Task Scheduling",
                        subtitle: "You will be asked to complete a task once every month, starting today."
                    )
                    Spacer()
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    Text("The task will take approximately 10 minutes to complete.")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Continue",
                    action: {
                        /* DISABLED - not currently working
                        // Schedule the edmonton task starting today
                        // for the next 12 months

                        // Get the day from today's date, which is the same day
                        // we want to repeat the task on every month.
                        // let dayOfMonth = Calendar.current.dateComponents([.day], from: Date())

                        // Create the task to schedule

                        let task = Task(
                            title: String(
                                localized: "RESEARCHKIT_TASK_TITLE",
                                bundle: .module
                            ),
                            description: String(
                                localized: "RESEARCHKIT_TASK_DESCRIPTION",
                                bundle: .module
                            ),
                            schedule: Schedule(
                                start: Calendar.current.startOfDay(for: Date()),
                                dateComponents: dayOfMonth,
                                end: .numberOfEvents(12)
                            ),
                            context: UtahTaskContext.researchKitTask(.edmonton)
                        )

                        // Schedule the task using the CardinalKit Scheduler
                        scheduler.schedule(task: task)
                         */

                        // Request permission to show local notifications
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                // Configure notification content
                                let content = UNMutableNotificationContent()
                                content.title = "Complete your survey"
                                content.subtitle = "Take the Edmonton survey today!"
                                content.sound = UNNotificationSound.default

                                // Configuring a recurring date for the notification
                                var dateComponents = DateComponents()
                                dateComponents.day = Calendar.current.component(.day, from: Date())
                                dateComponents.hour = 10
                                dateComponents.minute = 0

                                // Set up notification schedule
                                let trigger = UNCalendarNotificationTrigger(
                                    dateMatching: dateComponents,
                                    repeats: true
                                )

                                // Create the notification request
                                let request = UNNotificationRequest(
                                    identifier: UUID().uuidString,
                                    content: content,
                                    trigger: trigger
                                )

                                // Add the notification request to the notification center
                                UNUserNotificationCenter.current().add(request)
                            } else if let error = error {
                                print("Couldn't get permission for notifications: \(error.localizedDescription)")
                            }

                            // Onboarding is now complete
                            completedOnboardingFlow = true
                        }
                    }
                )
            }
        )
    }
}


struct TaskScheduling_Previews: PreviewProvider {
    static var previews: some View {
        TaskScheduling()
    }
}
