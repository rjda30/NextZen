import SwiftUI

// MARK: - Hero Card
struct DashboardHeroCard: View {
    let homeName: String
    let totalItems: Int
    let totalRooms: Int
    let alertCount: Int

    private let accent = Color(hex: "1A6BFF")

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back 👋")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                    Text(homeName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "house.lodge.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            HStack(spacing: 0) {
                statPill(value: "\(totalItems)", label: "Items", icon: "cube.fill")
                Spacer()
                statPill(value: "\(totalRooms)", label: "Rooms", icon: "square.grid.2x2.fill")
                Spacer()
                statPill(value: "\(alertCount)", label: "Alerts", icon: "bell.fill")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(hex: "1A6BFF"), Color(hex: "0049CC")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(hex: "1A6BFF").opacity(0.3), radius: 12, y: 4)
    }

    private func statPill(value: String, label: String, icon: String) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                Text(label).font(.caption2).foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 9)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Room Card (Dashboard)
struct DashRoomCard: View {
    let room: HomeRoom

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: room.icon)
                    .font(.system(size: 18))
                    .foregroundColor(room.color)
                    .frame(width: 44, height: 44)
                    .background(room.color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(.systemGray3))
            }
            Text(room.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            Text("\(room.itemCount) item\(room.itemCount == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

// MARK: - Item Row (Dashboard)
struct DashItemRow: View {
    let item: HomeItem

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.system(size: 17))
                .foregroundColor(Color(hex: "1A6BFF"))
                .frame(width: 44, height: 44)
                .background(Color(hex: "1A6BFF").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 11))
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                Text("\(item.brand.isEmpty ? item.category : item.brand) · \(item.category)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.systemGray3))
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

// MARK: - Alert Row (Dashboard)
struct DashAlertRow: View {
    let alert: MaintenanceReminder

    var body: some View {
        let dueDateText = RelativeDateTimeFormatter().localizedString(for: alert.dueDate, relativeTo: Date())
        let isUrgent = alert.isUrgent || alert.dueDate < Date().addingTimeInterval(86400 * 3)
        return HStack(spacing: 14) {
            Image(systemName: alert.icon)
                .font(.system(size: 16))
                .foregroundColor(isUrgent ? .white : Color(hex: "FF6B2B"))
                .frame(width: 44, height: 44)
                .background(isUrgent ? Color(hex: "FF3B30") : Color(hex: "FF6B2B").opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 11))
            VStack(alignment: .leading, spacing: 3) {
                Text(alert.title)
                    .font(.system(size: 15, weight: .medium))
                Text("\(alert.itemName) · \(dueDateText)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.systemGray3))
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

// MARK: - Section Wrapper (kept for other views)
struct DashboardSectionView<Content: View>: View {
    let title: String
    let actionLabel: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                if let actionLabel {
                    Button(actionLabel) {}
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(Color(hex: "1A6BFF"))
                }
            }
            content()
        }
    }
}
