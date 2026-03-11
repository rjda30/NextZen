import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeStore: HomeStore
    @EnvironmentObject var appState: AppState
    @State private var showResetAlert = false
    @State private var notificationsEnabled = true
    @State private var warrantyAlerts = true
    @State private var maintenanceAlerts = true

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    profileHeader
                    statsSection
                    settingsSection
                    subscriptionCard
                    dangerZone
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6).opacity(0.5))
            .navigationTitle("Profile")
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 64, height: 64)
                Text("JD").font(.system(size: 24, weight: .bold)).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Jamie Doe").font(.title3.bold())
                Text("jamie.doe@email.com").font(.subheadline).foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill").font(.caption).foregroundColor(.orange)
                    Text("Free Plan").font(.caption.weight(.semibold)).foregroundColor(.orange)
                }
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "pencil.circle.fill").font(.title2).foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            statCard(value: "\(homeStore.allItems.count)", label: "Items", icon: "cube.fill", color: .blue)
            statCard(value: "\(homeStore.rooms.count)", label: "Rooms", icon: "square.grid.2x2.fill", color: .purple)
            statCard(value: "\(homeStore.activeReminders.count)", label: "Alerts", icon: "bell.fill", color: .orange)
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2).foregroundColor(color)
            Text(value).font(.system(size: 22, weight: .bold))
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications").font(.system(size: 18, weight: .bold))
            VStack(spacing: 0) {
                toggleRow(label: "Push Notifications", icon: "bell.fill", color: .blue, binding: $notificationsEnabled)
                Divider().padding(.leading, 52)
                toggleRow(label: "Warranty Alerts", icon: "checkmark.shield.fill", color: .green, binding: $warrantyAlerts)
                Divider().padding(.leading, 52)
                toggleRow(label: "Maintenance Reminders", icon: "wrench.fill", color: .orange, binding: $maintenanceAlerts)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            Text("Account").font(.system(size: 18, weight: .bold)).padding(.top, 4)
            VStack(spacing: 0) {
                settingRow(label: "Edit Home Name", icon: "house.fill", color: .purple)
                Divider().padding(.leading, 52)
                settingRow(label: "Privacy Policy", icon: "lock.fill", color: .gray)
                Divider().padding(.leading, 52)
                settingRow(label: "Terms of Service", icon: "doc.text.fill", color: .gray)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
    }

    private func toggleRow(label: String, icon: String, color: Color, binding: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).foregroundColor(.white).font(.body)
                .frame(width: 36, height: 36)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 9))
            Text(label).font(.system(size: 15))
            Spacer()
            Toggle("", isOn: binding).labelsHidden().tint(.black)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }

    private func settingRow(label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).foregroundColor(.white).font(.body)
                .frame(width: 36, height: 36)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 9))
            Text(label).font(.system(size: 15))
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }

    private var subscriptionCard: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Premium").font(.system(size: 17, weight: .bold))
                    Text("Unlock AI search, unlimited items & more").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "crown.fill").font(.title).foregroundColor(.orange)
            }
            Button(action: {}) {
                Text("Upgrade · $9.99/mo")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")],
                                              startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white).clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var dangerZone: some View {
        VStack(spacing: 10) {
            Button(role: .destructive, action: { showResetAlert = true }) {
                Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color.red.opacity(0.08)).foregroundColor(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .alert("Reset Onboarding?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) { appState.hasCompletedOnboarding = false }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will show the onboarding screens again on next launch.")
        }
    }
}
