import SwiftUI

// MARK: - Inventory Chart
struct InventoryChartView: View {
    let data: [(String, Double, Color)]

    private var total: Double { data.reduce(0) { $0 + $1.1 } }

    var body: some View {
        VStack(spacing: 16) {
            chartBar
            legendGrid
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var chartBar: some View {
        GeometryReader { geo in
            HStack(spacing: 2) {
                ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                    let fraction = item.1 / total
                    RoundedRectangle(cornerRadius: 4)
                        .fill(item.2)
                        .frame(width: max(geo.size.width * fraction - 2, 4))
                }
            }
        }
        .frame(height: 28)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var legendGrid: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: cols, alignment: .leading, spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                legendItem(label: item.0, value: item.1, color: item.2)
            }
        }
    }

    private func legendItem(label: String, value: Double, color: Color) -> some View {
        HStack(spacing: 8) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label).font(.caption).foregroundColor(.primary)
            Spacer()
            Text("\(Int(value))%").font(.caption.weight(.semibold)).foregroundColor(.secondary)
        }
    }
}

// MARK: - Alerts List
struct AlertsListView: View {
    let alerts: [MaintenanceAlert]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(alerts) { alert in
                alertRow(alert: alert)
            }
        }
    }

    private func alertRow(alert: MaintenanceAlert) -> some View {
        HStack(spacing: 14) {
            Image(systemName: alert.icon)
                .font(.body)
                .foregroundColor(alert.isUrgent ? .white : .orange)
                .frame(width: 40, height: 40)
                .background(alert.isUrgent ? Color.red : Color.orange.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(alert.title)
                    .font(.system(size: 15, weight: .medium))
                Text(alert.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

// MARK: - Recent Items
struct RecentItemsView: View {
    let items: [HomeItem]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(items) { item in
                itemRow(item: item)
            }
        }
    }

    private func itemRow(item: HomeItem) -> some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 15, weight: .medium))
                Text("\(item.brand) · \(item.room)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}
