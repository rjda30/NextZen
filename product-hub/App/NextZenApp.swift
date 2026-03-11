import SwiftUI

@main
struct NextZenApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var homeStore = HomeStore()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(appState)
                    .environmentObject(homeStore)
            } else {
                OnboardingFlowView()
                    .environmentObject(appState)
                    .environmentObject(homeStore)
            }
        }
    }
}
