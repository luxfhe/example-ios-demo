// Copyright © 2025 Lux. All rights reserved.

import SwiftUI

#Preview {
    HealthRoot()
}

struct HealthRoot: View {
    @State private var selectedTab: HealthTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            tabItem(value: .home) {
                HomeTab(selectedTab: $selectedTab)
            }

            tabItem(value: .sleep) {
                SleepTab()
            }

            tabItem(value: .weight) {
                WeightTab()
            }
        }
        .tint(.luxOrange)
        .overlay(alignment: .topTrailing) {
            LuxLink()
        }
        .overlay(alignment: .topTrailing) {
            LuxInfoButton()
        }
        .onOpenURL { url in
            selectedTab = HealthTab(url: url) ?? .home
        }
    }

    @TabContentBuilder<HealthTab>
    private func tabItem<Content: View>(value: HealthTab, @ViewBuilder content: () -> Content) -> some TabContent<HealthTab> {
        Tab(value.displayInfo.name, systemImage: value.displayInfo.icon, value: value) {
            content()
                .toolbarBackground(Color.luxGreyBackground, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        }
    }
}
