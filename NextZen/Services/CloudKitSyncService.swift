import Foundation
import CloudKit
import SwiftUI

// MARK: - iCloud Key-Value Sync
// Syncs lightweight user preferences across the user's iCloud-connected devices.
// Full CloudKit record sync is handled by Supabase; this layer syncs settings only.

final class CloudSyncService: ObservableObject {
    static let shared = CloudSyncService()
    private let store = NSUbiquitousKeyValueStore.default

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kvStoreDidChange(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: store
        )
        store.synchronize()
    }

    // MARK: - Persist & restore home name
    func saveHomeName(_ name: String) {
        store.set(name, forKey: "homeName")
        store.synchronize()
    }

    func loadHomeName() -> String? {
        store.string(forKey: "homeName")
    }

    // MARK: - Persist & restore onboarding answers
    func saveOnboardingProfile(_ profile: OnboardingProfile) {
        store.set(profile.homeType, forKey: "onboarding.homeType")
        store.set(profile.homeSize, forKey: "onboarding.homeSize")
        store.set(profile.primaryGoal, forKey: "onboarding.primaryGoal")
        store.synchronize()
    }

    func loadOnboardingProfile() -> OnboardingProfile? {
        guard
            let t = store.string(forKey: "onboarding.homeType"),
            let s = store.string(forKey: "onboarding.homeSize"),
            let g = store.string(forKey: "onboarding.primaryGoal")
        else { return nil }
        return OnboardingProfile(homeType: t, homeSize: s, primaryGoal: g)
    }

    // MARK: - Notifications from other devices
    @objc private func kvStoreDidChange(_ notification: Notification) {
        store.synchronize()
        NSLog("[CloudSyncService] iCloud KV store updated from remote device")
        NotificationCenter.default.post(name: .cloudSyncDidUpdate, object: nil)
    }
}

// MARK: - Supporting Types
struct OnboardingProfile {
    var homeType: String
    var homeSize: String
    var primaryGoal: String
}

extension Notification.Name {
    static let cloudSyncDidUpdate = Notification.Name("cloudSyncDidUpdate")
}


