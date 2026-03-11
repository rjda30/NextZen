import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: HomeStore

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    heroCard
                    quickActions
                    roomsSection
                    inventoryChart
                    alertsSection
                    recentItemsSection
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6).opacity(0.5))
            .navigationTitle(store.homeName)
            .toolbar { toolbarContent }
        }
    }

    // MARK: - Hero
    private var heroCard: some View {
        HeroCardView(
            totalItems: store.allItems.count,
            totalRooms: store.rooms.count,
            alertCount: store.urgentCount
        )
    }

    // MARK: - Quick Actions
    private var quickActions: some View {
        QuickActionsRow()
    }

    // MARK: - Rooms
    private var roomsSection: some View {
        DashboardSectionView(title: "Rooms", actionLabel: "See All") {
            RoomsGridView(rooms: store.rooms)
        }
    }

    // MARK: - Chart
    private var inventoryChart: some View {
        DashboardSectionView(title: "Inventory Breakdown", actionLabel: nil) {
            InventoryChartView(data: store.categoryDistribution)
        }
    }

    // MARK: - Alerts
    private var alertsSection: some View {
        DashboardSectionView(title: "Upcoming Alerts", actionLabel: "View All") {
            AlertsListView(alerts: Array(store.activeReminders.prefix(3)))
        }
    }

    // MARK: - Recent Items
    private var recentItemsSection: some View {
        let recent = Array(store.allItems.sorted { $0.createdAt > $1.createdAt }.prefix(4))
        return DashboardSectionView(title: "Recent Items", actionLabel: "View All") {
            RecentItemsView(items: recent)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
    }
}
