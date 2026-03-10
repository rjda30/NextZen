import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppState.Tab.home)
            RoomsPlaceholderView()
                .tabItem { Label("Rooms", systemImage: "square.grid.2x2.fill") }
                .tag(AppState.Tab.rooms)
            SearchPlaceholderView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(AppState.Tab.search)
            AlertsPlaceholderView()
                .tabItem { Label("Alerts", systemImage: "bell.fill") }
                .tag(AppState.Tab.alerts)
            ProfilePlaceholderView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(AppState.Tab.profile)
        }
        .tint(.black)
    }
}
