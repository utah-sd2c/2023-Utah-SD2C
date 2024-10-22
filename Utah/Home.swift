//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UtahProfile
import UtahSchedule
import UtahSharedContext
import UtahTrends
import BackgroundTasks

struct HomeView: View {
    enum Tabs: String {
        case schedule
        case profile
        case trends
    }
    
    @EnvironmentObject var healthKitManager: HealthKitManager
    @Environment(\.scenePhase) var scenePhase
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule
    @State private var backgroundSyncTimer: Timer? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView()
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Trends()
                .tag(Tabs.trends)
                .tabItem {
                    Label("TRENDS_TAB_TITLE", systemImage: "chart.line.uptrend.xyaxis")
                }
            Profile()
                .tag(Tabs.profile)
                .tabItem {
                    Label("PROFILE_TAB_TITLE", systemImage: "person.fill")
                }
        }
        .onAppear {
                  syncData()
                  startBackgroundSyncTimer()
              }
              .onChange(of: scenePhase) { newPhase in
                  if newPhase == .active {
                      // Data is synced when the app enters the foreground
                      syncData()
                      startBackgroundSyncTimer()
                  } else if newPhase == .background {
                      syncData()
                      startBackgroundSyncTimer()
                  } else if newPhase == .inactive {
                      stopBackgroundSyncTimer()
                  }
              }
              .onChange(of: selectedTab) { _ in
                  syncData()
              }
          }
          
          // This is a Sync function for step and distance data
          private func syncData() {
              healthKitManager.StepCountCollectionExistsAndUpload { success in
                  if success {
                      print("Step data synced successfully.")
                  } else {
                      print("Failed to sync Step data.")
                  }
                  
                  healthKitManager.DistanceDataCollectionExistsAndUpload { success in
                      if success {
                          print("Distance data synced successfully.")
                      } else {
                          print("Failed to sync Distance data.")
                      }
                  }
              }
          }
          
          private func startBackgroundSyncTimer() {
              stopBackgroundSyncTimer()
              backgroundSyncTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                  print("Background sync triggered")
                  syncData()
              }
            
              UIApplication.shared.beginBackgroundTask(withName: "BackgroundStepSync") {
                  self.stopBackgroundSyncTimer()
              }
          }
    
          private func stopBackgroundSyncTimer() {
              backgroundSyncTimer?.invalidate()
              backgroundSyncTimer = nil
          }
      }


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UtahScheduler())
    }
}
#endif
