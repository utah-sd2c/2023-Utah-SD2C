//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import UtahContacts
import UtahMockDataStorageProvider
import UtahProfile
import UtahSchedule
import UtahSharedContext
import UtahTrends


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case contact
        case profile
        case mockUpload
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
            Contacts()
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.3.fill")
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
            MockUploadList()
                .tag(Tabs.mockUpload)
                .tabItem {
                    Label("MOCK_UPLOAD_TAB_TITLE", systemImage: "server.rack")
                }
        }
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UtahScheduler())
            .environmentObject(MockDataStorageProvider())
    }
}
#endif
