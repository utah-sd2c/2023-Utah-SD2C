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


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case profile
        case trends
    }
    
    
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule
    
    
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
