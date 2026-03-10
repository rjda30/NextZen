import SwiftUI

final class AppState: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @Published var selectedTab: Tab = .home

    enum Tab: Int, CaseIterable {
        case home, rooms, search, alerts, profile
    }
}
