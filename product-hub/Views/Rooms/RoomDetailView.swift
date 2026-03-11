import SwiftUI

struct RoomDetailView: View {
    @EnvironmentObject var homeStore: HomeStore
    let room: HomeRoom
    @State private var showAddItem = false

    private var currentRoom: HomeRoom {
        homeStore.rooms.first { $0.id == room.id } ?? room
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                roomHeader
                if currentRoom.items.isEmpty {
                    emptyState
                } else {
                    itemsList
                }
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color(.systemGray6).opacity(0.5))
        .navigationTitle(currentRoom.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showAddItem = true }) {
                    Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            AddItemSheet(preselectedRoomId: room.id, isPresented: $showAddItem)
                .environmentObject(homeStore)
        }
    }

    private var roomHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(currentRoom.color.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: currentRoom.icon)
                    .font(.system(size: 28))
                    .foregroundColor(currentRoom.color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(currentRoom.name).font(.title2.bold())
                Text("\(currentRoom.itemCount) item\(currentRoom.itemCount == 1 ? "" : "s") tracked")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var itemsList: some View {
        VStack(spacing: 10) {
            ForEach(currentRoom.items) { item in
                NavigationLink(destination: ItemDetailView(item: item).environmentObject(homeStore)) {
                    ItemRow(item: item)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cube.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary.opacity(0.4))
            Text("No items yet")
                .font(.headline)
            Text("Add items to this room to start tracking them.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Button(action: { showAddItem = true }) {
                Label("Add Item", systemImage: "plus")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.black).foregroundColor(.white).clipShape(Capsule())
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ItemRow: View {
    let item: HomeItem
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 46, height: 46)
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name).font(.system(size: 15, weight: .semibold))
                Text(item.brand.isEmpty ? item.category : "\(item.brand) · \(item.category)")
                    .font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            if let exp = item.warrantyExpires, exp > Date() {
                warrantyBadge(date: exp)
            }
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private func warrantyBadge(date: Date) -> some View {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        let isClose = days < 90
        return Text(isClose ? "\(days)d" : "Warranty")
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 7).padding(.vertical, 3)
            .background(isClose ? Color.orange.opacity(0.15) : Color.green.opacity(0.12))
            .foregroundColor(isClose ? .orange : .green)
            .clipShape(Capsule())
    }
}
