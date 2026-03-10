import SwiftUI

struct DashboardView: View {
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
            .navigationTitle("My Home")
            .toolbar { toolbarContent }
        }
    }

    // MARK: - Hero
    private var heroCard: some View {
        HeroCardView(
            totalItems: 67,
            totalRooms: SampleData.rooms.count,
            alertCount: SampleData.alerts.filter(\.isUrgent).count
        )
    }

    // MARK: - Quick Actions
    private var quickActions: some View {
        QuickActionsRow()
    }

    // MARK: - Rooms
    private var roomsSection: some View {
        DashboardSectionView(title: "Rooms", actionLabel: "See All") {
            RoomsGridView(rooms: SampleData.rooms)
        }
    }

    // MARK: - Chart
    private var inventoryChart: some View {
        DashboardSectionView(title: "Inventory Breakdown", actionLabel: nil) {
            InventoryChartView(data: SampleData.categoryDistribution)
        }
    }

    // MARK: - Alerts
    private var alertsSection: some View {
        DashboardSectionView(title: "Upcoming Alerts", actionLabel: "View All") {
            AlertsListView(alerts: Array(SampleData.alerts.prefix(3)))
        }
    }

    // MARK: - Recent Items
    private var recentItemsSection: some View {
        DashboardSectionView(title: "Recent Items", actionLabel: "View All") {
            RecentItemsView(items: Array(SampleData.items.prefix(4)))
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
