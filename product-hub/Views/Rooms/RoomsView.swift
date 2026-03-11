import SwiftUI

struct RoomsView: View {
    @EnvironmentObject var homeStore: HomeStore
    @State private var showAddRoom = false
    @State private var editingRoom: HomeRoom? = nil

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        NavigationStack {
            Group {
                if homeStore.rooms.isEmpty {
                    emptyState
                } else {
                    roomGrid
                }
            }
            .navigationTitle("Rooms")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddRoom = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2).foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showAddRoom) {
                AddRoomSheet(isPresented: $showAddRoom)
                    .environmentObject(homeStore)
            }
            .sheet(item: $editingRoom) { room in
                EditRoomSheet(room: room, isPresented: Binding(get: { editingRoom != nil }, set: { if !$0 { editingRoom = nil } }))
                    .environmentObject(homeStore)
            }
        }
    }

    private var roomGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(homeStore.rooms) { room in
                    NavigationLink(destination: RoomDetailView(room: room).environmentObject(homeStore)) {
                        RoomCard(room: room)
                            .contextMenu {
                                Button(action: { editingRoom = room }) {
                                    Label("Edit Room", systemImage: "pencil")
                                }
                                Button(role: .destructive, action: { homeStore.deleteRoom(id: room.id) }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
                addRoomCard
            }
            .padding(20)
        }
        .background(Color(.systemGray6).opacity(0.5))
    }

    private var addRoomCard: some View {
        Button(action: { showAddRoom = true }) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 52, height: 52)
                    Image(systemName: "plus").font(.title2).foregroundColor(.secondary)
                }
                Text("Add Room")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 1.5, dash: [6])))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 52))
                .foregroundColor(.secondary.opacity(0.4))
            Text("No rooms yet").font(.title2.bold())
            Text("Add your first room to start organizing your home.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Button(action: { showAddRoom = true }) {
                Text("Add First Room")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 32).padding(.vertical, 14)
                    .background(Color.black).foregroundColor(.white).clipShape(Capsule())
            }
            Spacer()
        }
        .padding(40)
    }
}

struct RoomCard: View {
    let room: HomeRoom
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(room.color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: room.icon)
                        .font(.system(size: 20))
                        .foregroundColor(room.color)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption).foregroundColor(.secondary)
            }
            Text(room.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            Text("\(room.itemCount) item\(room.itemCount == 1 ? "" : "s")")
                .font(.caption).foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}
