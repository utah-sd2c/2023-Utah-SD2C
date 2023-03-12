//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// swiftlint:disable closure_body_length
import Questionnaires
import Scheduler
import SwiftUI

public struct ScheduleView: View {
    @EnvironmentObject var scheduler: UtahScheduler
    @State var eventContextsByDate: [Date: [EventContext]] = [:]
    @State var presentedContext: EventContext?
    @State private var showingEdmontonSurvey = false
    @State private var showingWIQSurvey = false
    @State private var showingVEINESSurvey = false
    @State private var showingWalkTest = false
    
    var startOfDays: [Date] {
        Array(eventContextsByDate.keys)
    }
    
    private var temporyButtons: some View {
        VStack {
            Button("Edmonton Frail Scale") {
                showingEdmontonSurvey.toggle()
            }
            .foregroundColor(Color.white)
            .padding()
            .background(.red)
            .cornerRadius(10)
            .sheet(isPresented: $showingEdmontonSurvey) {
                EdmontonViewController()
            }
            .padding(.top, 130)
            Button("Walking Impairement Questionnaire") {
                showingWIQSurvey.toggle()
            }
            .foregroundColor(Color.white)
            .padding()
            .background(.blue)
            .cornerRadius(10)
            .sheet(isPresented: $showingWIQSurvey) {
                WIQViewController()
            }
            Button("VEINES-QOL/Sym Questionnaire") {
                showingVEINESSurvey.toggle()
            }
            .foregroundColor(Color.white)
            .padding()
            .background(.green)
            .cornerRadius(10)
            .sheet(isPresented: $showingVEINESSurvey) {
                VEINESViewController()
            }
            Button("6 Minute Walk Test (active task)") {
                showingWalkTest.toggle()
            }
            .foregroundColor(Color.white)
            .padding()
            .background(.pink)
            .cornerRadius(10)
            .sheet(isPresented: $showingWalkTest) {
                TimedWalkViewController()
            }
            .navigationTitle(String(localized: "QUESTIONNAIRE_LIST_TITLE", bundle: .module))
        }
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                List(startOfDays, id: \.timeIntervalSinceNow) { startOfDay in
                    Section(format(startOfDay: startOfDay)) {
                        ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                            EventContextView(eventContext: eventContext)
                                .onTapGesture {
                                    if !eventContext.event.complete {
                                        presentedContext = eventContext
                                    }
                                }
                        }
                    }
                }
                .onChange(of: scheduler) { _ in
                    calculateEventContextsByDate()
                }
                .task {
                    calculateEventContextsByDate()
                }
                .sheet(item: $presentedContext) { presentedContext in
                    destination(withContext: presentedContext)
                }
            }
        }
    }
    
    
    public init() {}
    
    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder
        var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { _ in
                    _Concurrency.Task {
                        await eventContext.event.complete(true)
                    }
                }
            case let .researchKitTask(researchKitTaskContext):
                if researchKitTaskContext == .edmonton {
                    EdmontonViewController()
                } else if researchKitTaskContext == .edmontonVEINES {
                    EdmontonVEINESViewController()
                } else if researchKitTaskContext == .edmontonWIQ {
                    EdmontonWIQViewController()
                }
            }
        }
        return destination
    }
    
    
    private func format(startOfDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: startOfDay)
    }
    
    private func calculateEventContextsByDate() {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: .now),
                    to: .numberOfEventsOrEndDate(100, .now)
                )
                .map { event in
                    EventContext(event: event, task: task)
                }
        }
            .sorted()
        
        let newEventContextsByDate = Dictionary(grouping: eventContexts) { eventContext in
            Calendar.current.startOfDay(for: eventContext.event.scheduledAt)
        }
        
        if newEventContextsByDate != eventContextsByDate {
            eventContextsByDate = newEventContextsByDate
        }
    }
}

#if DEBUG
struct SchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .environmentObject(
                UtahScheduler()
            )
    }
}
#endif
