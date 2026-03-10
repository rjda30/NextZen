import SwiftUI

// MARK: - Hero Card
struct HeroCardView: View {
    let totalItems: Int
    let totalRooms: Int
    let alertCount: Int

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back 👋")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    Text("My Apartment")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "house.lodge.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.6))
            }
            statsRow
        }
        .padding(20)
        .background(heroGradient)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            statPill(value: "\(totalItems)", label: "Items", icon: "cube.fill")
            Spacer()
            statPill(value: "\(totalRooms)", label: "Rooms", icon: "square.grid.2x2.fill")
            Spacer()
            statPill(value: "\(alertCount)", label: "Alerts", icon: "bell.fill")
        }
    }

    private func statPill(value: String, label: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                Text(label).font(.caption2).foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.12))
        .clipShape(Capsule())
    }

    private var heroGradient: some ShapeStyle {
        LinearGradient(colors: [Color.black, Color(white: 0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Quick Actions
struct QuickActionsRow: View {
    private let actions: [(String, String, Color)] = [
        ("Add Item", "plus.circle.fill", .black),
        ("Add Room", "square.grid.2x2.fill", .blue),
        ("Scan", "barcode.viewfinder", .orange),
        ("Search", "magnifyingglass", .purple)
    ]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(actions, id: \.0) { action in
                quickActionButton(title: action.0, icon: action.1, color: action.2)
            }
        }
    }

    private func quickActionButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Section Wrapper
struct DashboardSectionView<Content: View>: View {
    let title: String
    let actionLabel: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                if let actionLabel {
                    Button(actionLabel) {}
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                }
            }
            content()
        }
    }
}

// MARK: - Rooms Grid
struct RoomsGridView: View {
    let rooms: [HomeRoom]
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(rooms.prefix(4)) { room in
                roomCard(room: room)
            }
        }
    }

    private func roomCard(room: HomeRoom) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: room.icon)
                .font(.title2)
                .foregroundColor(room.color)
                .frame(width: 44, height: 44)
                .background(room.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(room.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            Text("\(room.itemCount) items")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}
