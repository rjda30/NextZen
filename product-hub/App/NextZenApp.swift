import SwiftUI

@main
struct NextZenApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var homeStore = HomeStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(homeStore)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else if appState.hasCompletedOnboarding {
                MainTabView()
                    .transition(.opacity)
            } else {
                OnboardingFlowView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.4), value: appState.hasCompletedOnboarding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                showSplash = false
            }
        }
    }
}
