//
//  Tab.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//


import SwiftUI

enum Tab {
    case home, calendar, bookmarks, weather, settings
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var tabBarManager: TabBarManager
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .calendar:
                    CalendarView()
                case .bookmarks:
                    BookmarksView()
                case .weather:
                    WeatherView()
                case .settings:
                    SettingsView()
                }
            }
           
            VStack {
                Spacer()
                
                if !tabBarManager.isTabBarHidden {
                    CustomTabBar(selectedTab: $selectedTab)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.05), value: tabBarManager.isTabBarHidden)
                }
            }
            
        } .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
