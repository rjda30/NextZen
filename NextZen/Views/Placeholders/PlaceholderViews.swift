import SwiftUI

// MARK: - Rooms Placeholder
struct RoomsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            PlaceholderContent(
                icon: "square.grid.2x2.fill",
                title: "Your Rooms",
                subtitle: "Add and manage rooms in your home. Each room holds its own inventory.",
                buttonLabel: "Add First Room"
            )
            .navigationTitle("Rooms")
        }
    }
}

// MARK: - Search Placeholder
struct SearchPlaceholderView: View {
    var body: some View {
        NavigationStack {
            PlaceholderContent(
                icon: "magnifyingglass",
                title: "AI-Powered Search",
                subtitle: "Search your entire home inventory using natural language.\n\"Where is the air purifier manual?\"",
                buttonLabel: "Try a Search"
            )
            .navigationTitle("Search")
        }
    }
}

// MARK: - Alerts Placeholder
struct AlertsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            PlaceholderContent(
                icon: "bell.badge.fill",
                title: "Maintenance Alerts",
                subtitle: "Get reminders for filter changes, warranty expirations, and scheduled maintenance.",
                buttonLabel: "Set Up Alerts"
            )
            .navigationTitle("Alerts")
        }
    }
}

// MARK: - Profile Placeholder
struct ProfilePlaceholderView: View {
    var body: some View {
        NavigationStack {
            PlaceholderContent(
                icon: "person.crop.circle.fill",
                title: "Your Profile",
                subtitle: "Manage your account, notification settings, and subscription.",
                buttonLabel: "Edit Profile"
            )
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Generic Placeholder
struct PlaceholderContent: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonLabel: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            iconView
            textContent
            actionButton
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private var iconView: some View {
        Image(systemName: icon)
            .font(.system(size: 56))
            .foregroundColor(.black)
            .frame(width: 100, height: 100)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var textContent: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var actionButton: some View {
        Button(action: {}) {
            Text(buttonLabel)
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}
