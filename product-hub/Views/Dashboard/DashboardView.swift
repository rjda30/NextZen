import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: HomeStore
    @EnvironmentObject var appState: AppState
    @State private var showAddItem = false
    @State private var showAddRoom = false
    @State private var showSearch = false
    @State private var showScan = false
    @State private var selectedRoom: HomeRoom? = nil
    @State private var navigateToRoom = false

    private let accent = Color(hex: "1A6BFF")
    private let orange = Color(hex: "FF6B2B")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    heroCard
                    quickActionsSection
                    roomsSection
                    recentItemsSection
                    alertsSection
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemGray6).opacity(0.4))
            .navigationTitle(store.homeName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar { toolbarItems }
            .sheet(isPresented: $showAddItem) {
                AddItemSheet(preselectedRoomId: nil, isPresented: $showAddItem)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showAddRoom) {
                AddRoomSheet(isPresented: $showAddRoom)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showScan) {
                ScanView().environmentObject(store)
            }
            .sheet(isPresented: $showSearch) {
                SearchView().environmentObject(store)
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedRoom != nil },
                set: { if !$0 { selectedRoom = nil } }
            )) {
                if let room = selectedRoom {
                    RoomDetailView(room: room).environmentObject(store)
                }
            }
        }
    }

    // MARK: - Hero
    private var heroCard: some View {
        DashboardHeroCard(
            homeName: store.homeName,
            totalItems: store.allItems.count,
            totalRooms: store.rooms.count,
            alertCount: store.urgentCount
        )
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            HStack(spacing: 12) {
                quickAction(label: "Add Item", icon: "plus.circle.fill", color: accent) {
                    showAddItem = true
                }
                quickAction(label: "Scan", icon: "barcode.viewfinder", color: orange) {
                    showScan = true
                }
                quickAction(label: "Add Room", icon: "square.grid.2x2.fill", color: Color(hex: "34C759")) {
                    showAddRoom = true
                }
                quickAction(label: "Search", icon: "magnifyingglass", color: Color(hex: "AF52DE")) {
                    showSearch = true
                }
            }
        }
    }

    private func quickAction(label: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                    .frame(width: 52, height: 52)
                    .background(color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Rooms
    private var roomsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Rooms")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("See All") { appState.selectedTab = .rooms }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(accent)
            }
            if store.rooms.isEmpty {
                emptyRoomsCard
            } else {
                roomsGrid
            }
        }
    }

    private var roomsGrid: some View {
        let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: cols, spacing: 12) {
            ForEach(store.rooms.prefix(4)) { room in
                Button(action: { selectedRoom = room }) {
                    DashRoomCard(room: room)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var emptyRoomsCard: some View {
        Button(action: { showAddRoom = true }) {
            HStack(spacing: 14) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2).foregroundColor(accent)
                Text("Add your first room")
                    .font(.system(size: 15, weight: .medium)).foregroundColor(accent)
                Spacer()
            }
            .padding(18)
            .background(accent.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Recent Items
    private var recentItemsSection: some View {
        let recent = Array(store.allItems.sorted { $0.createdAt > $1.createdAt }.prefix(4))
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent Items")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                if recent.count > 0 {
                    Button("View All") { appState.selectedTab = .rooms }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(accent)
                }
            }
            if recent.isEmpty {
                emptyItemsCard
            } else {
                VStack(spacing: 10) {
                    ForEach(recent) { item in
                        DashItemRow(item: item)
                    }
                }
            }
        }
    }

    private var emptyItemsCard: some View {
        Button(action: { showAddItem = true }) {
            HStack(spacing: 14) {
                Image(systemName: "cube.box.fill")
                    .font(.title2).foregroundColor(orange)
                Text("Add your first item")
                    .font(.system(size: 15, weight: .medium)).foregroundColor(orange)
                Spacer()
            }
            .padding(18)
            .background(orange.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Alerts
    private var alertsSection: some View {
        let alerts = Array(store.activeReminders.prefix(3))
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Upcoming Alerts")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("View All") { appState.selectedTab = .alerts }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(accent)
            }
            VStack(spacing: 10) {
                ForEach(alerts) { alert in
                    DashAlertRow(alert: alert)
                }
            }
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { showAddItem = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "1A6BFF"))
            }
        }
    }
}
