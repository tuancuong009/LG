//
//  CustomTabBar.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            tabButton(icon: "tab_home", iconSelect: "tab_home2", title: "Home", tab: .home)
            tabButton(icon: "tab_calendar", iconSelect: "tab_calendar2", title: "Calendar", tab: .calendar)
            tabButton(icon: "tab_bookmark", iconSelect: "tab_bookmark2", title: "Bookmarks", tab: .bookmarks)
            tabButton(icon: "tab_weather", iconSelect: "tab_weather2", title: "Weather", tab: .weather)
            tabButton(icon: "tab_setting", iconSelect: "tab_setting2", title: "Settings", tab: .settings)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(
            Color(hex: "808080").opacity(0.4)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }

    func tabButton(icon: String, iconSelect: String, title: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(selectedTab == tab ? iconSelect : icon)
                Text(title)
                    .font(selectedTab == tab ? .appFontSemibold(10) : .appFontMedium(10))
            }
            .foregroundColor(selectedTab == tab ? Color.colorMain : .white50)
            .frame(maxWidth: .infinity)
        }
    }
}
