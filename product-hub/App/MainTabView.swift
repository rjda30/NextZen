import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var homeStore: HomeStore
    @State private var showScan = false

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppState.Tab.home)

            RoomsView()
                .tabItem { Label("Rooms", systemImage: "square.grid.2x2.fill") }
                .tag(AppState.Tab.rooms)

            Color.clear
                .tabItem { Label("Scan", systemImage: "barcode.viewfinder") }
                .tag(AppState.Tab.scan)

            AlertsView()
                .tabItem { Label("Alerts", systemImage: "bell.fill") }
                .tag(AppState.Tab.alerts)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(AppState.Tab.profile)
        }
        .tint(.black)
        .onChange(of: appState.selectedTab) { tab in
            if tab == .scan {
                showScan = true
                appState.selectedTab = .home
            }
        }
        .sheet(isPresented: $showScan) {
            ScanView()
                .environmentObject(homeStore)
        }
    }
}
