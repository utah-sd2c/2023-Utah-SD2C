//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import FHIR
import Foundation
import Scheduler
import UtahSharedContext


/// A `Scheduler` using the `FHIR` standard as well as the ``UtahTaskContext`` to schedule and manage tasks and events in the
/// CardinalKit Utah Applciation.
public typealias UtahScheduler = Scheduler<FHIR, UtahTaskContext>

extension UtahScheduler {
    /// Creates a default instance of the ``UtahScheduler`` by scheduling the tasks listed below.
    public convenience init() {
        self.init(
            tasks: [
                Task(
                    title: String(localized: "QUESTIONNAIRE_TASK_TITLE", bundle: .module),
                    description: String(localized: "RESEARCHKIT_TASK_DESCRIPTION", bundle: .module),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: Date()),
                        dateComponents: .init(hour: 10, minute: 00), // Every Day at 10:00 AM
                        end: .numberOfEvents(356)
                    ),
                    context: UtahTaskContext.researchKitTask(ResearchKitTaskContext.edmonton)
                )
            ]
        )
    }
}
