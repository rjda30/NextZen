import SwiftUI
import RevenueCat

// MARK: - RevenueCat API Key
// Replace with your actual key from https://app.revenuecat.com
private let revenueCatAPIKey = "appl_REPLACE_WITH_YOUR_REVENUECAT_KEY"

@main
struct NextZenApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var homeStore = HomeStore()
    @StateObject private var purchases = PurchaseService.shared
    @StateObject private var auth = AuthService.shared

    init() {
        // Configure RevenueCat (use your actual key from RevenueCat dashboard)
        Purchases.logLevel = .error
        PurchaseService.shared.configure(apiKey: revenueCatAPIKey)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(homeStore)
                .environmentObject(purchases)
                .environmentObject(auth)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var homeStore: HomeStore
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else if appState.hasCompletedOnboarding {
                MainTabView()
                    .transition(.opacity)
                    .task { await syncOnLaunch() }
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
                Task { await auth.checkSession() }
            }
        }
    }

    private func syncOnLaunch() async {
        // Sign in anonymously if no session
        if auth.currentUser == nil {
            await auth.signInAnonymously()
        }
        if let uid = auth.currentUser?.id {
            await homeStore.syncFromSupabase(userId: uid)
        }
    }
}
