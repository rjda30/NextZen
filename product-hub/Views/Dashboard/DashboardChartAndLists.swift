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
                    let fraction = total > 0 ? item.1 / total : 0
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

// MARK: - Alerts List (used in AlertsView)
struct AlertsListView: View {
    let alerts: [MaintenanceReminder]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(alerts) { alert in
                DashAlertRow(alert: alert)
            }
        }
    }
}

// MARK: - Recent Items (used in other views)
struct RecentItemsView: View {
    let items: [HomeItem]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(items) { item in
                DashItemRow(item: item)
            }
        }
    }
}
