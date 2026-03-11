import SwiftUI

struct SearchView: View {
    @EnvironmentObject var homeStore: HomeStore
    @State private var query = ""
    @FocusState private var isFocused: Bool

    private let suggestions = [
        "Where is the air purifier manual?",
        "What's in the kitchen?",
        "Show items with warranty",
        "Appliances in bedroom"
    ]

    private var results: SearchResults {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return SearchResults(rooms: [], items: [])
        }
        let q = query.lowercased()
        let matchedRooms = homeStore.rooms.filter { $0.name.lowercased().contains(q) }
        let matchedItems = homeStore.allItems.filter {
            $0.name.lowercased().contains(q) ||
            $0.brand.lowercased().contains(q) ||
            $0.category.lowercased().contains(q) ||
            $0.model.lowercased().contains(q) ||
            $0.notes.lowercased().contains(q)
        }
        return SearchResults(rooms: matchedRooms, items: matchedItems)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                Divider()
                if query.isEmpty {
                    suggestionsView
                } else if results.isEmpty {
                    emptyResults
                } else {
                    resultsList
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search items, rooms, documents...", text: $query)
                .focused($isFocused)
                .autocorrectionDisabled()
            if !query.isEmpty {
                Button(action: { query = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var suggestionsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                aiSearchBanner
                VStack(alignment: .leading, spacing: 12) {
                    Text("Try asking...").font(.system(size: 16, weight: .semibold)).padding(.horizontal, 20)
                    ForEach(suggestions, id: \.self) { s in
                        Button(action: { query = s; isFocused = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles").foregroundColor(Color(hex: "6C63FF"))
                                Text(s).font(.subheadline).foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.left").font(.caption).foregroundColor(.secondary)
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                recentSummary
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGray6).opacity(0.5))
    }

    private var aiSearchBanner: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Image(systemName: "sparkles").font(.title3).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("AI-Powered Search").font(.system(size: 15, weight: .semibold))
                Text("Search your entire home inventory using natural language.").font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        .padding(.horizontal, 20)
    }

    private var recentSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Inventory").font(.system(size: 16, weight: .semibold)).padding(.horizontal, 20)
            HStack(spacing: 12) {
                statChip(value: "\(homeStore.allItems.count)", label: "Items", icon: "cube.fill", color: .blue)
                statChip(value: "\(homeStore.rooms.count)", label: "Rooms", icon: "square.grid.2x2.fill", color: .purple)
                statChip(value: "\(homeStore.activeReminders.count)", label: "Alerts", icon: "bell.fill", color: .orange)
            }
            .padding(.horizontal, 20)
        }
    }

    private func statChip(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.title3).foregroundColor(color)
            Text(value).font(.system(size: 18, weight: .bold))
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private var resultsList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !results.rooms.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Rooms", count: results.rooms.count)
                        ForEach(results.rooms) { room in
                            NavigationLink(destination: RoomDetailView(room: room).environmentObject(homeStore)) {
                                roomResultRow(room: room)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                if !results.items.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        sectionLabel("Items", count: results.items.count)
                        ForEach(results.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item).environmentObject(homeStore)) {
                                itemResultRow(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemGray6).opacity(0.5))
    }

    private func sectionLabel(_ title: String, count: Int) -> some View {
        HStack {
            Text(title).font(.system(size: 16, weight: .bold))
            Text("\(count)").font(.caption.weight(.semibold))
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Color.black.opacity(0.08))
                .clipShape(Capsule())
        }
    }

    private func roomResultRow(room: HomeRoom) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(room.color.opacity(0.15)).frame(width: 44, height: 44)
                Image(systemName: room.icon).font(.system(size: 18)).foregroundColor(room.color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(room.name).font(.system(size: 15, weight: .semibold))
                Text("\(room.itemCount) items").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding(14).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private func itemResultRow(item: HomeItem) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)).frame(width: 44, height: 44)
                Image(systemName: item.icon).font(.system(size: 18)).foregroundColor(.black)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name).font(.system(size: 15, weight: .semibold))
                let roomName = homeStore.room(for: item)?.name ?? ""
                Text(item.brand.isEmpty ? roomName : "\(item.brand) · \(roomName)")
                    .font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding(14).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private var emptyResults: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass").font(.system(size: 44)).foregroundColor(.secondary.opacity(0.4))
            Text("No results for \"\(query)\"").font(.headline)
            Text("Try searching for a room name, brand, or item category.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Spacer()
        }
        .padding(40)
    }
}

struct SearchResults {
    let rooms: [HomeRoom]
    let items: [HomeItem]
    var isEmpty: Bool { rooms.isEmpty && items.isEmpty }
}
