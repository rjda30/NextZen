import SwiftUI

struct AddRoomSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var selectedIcon = HomeRoom.iconOptions[0].0
    @State private var selectedColor = HomeRoom.iconOptions[0].1

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    previewCard
                    nameSection
                    iconSection
                }
                .padding(20)
            }
            .navigationTitle("New Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private var previewCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(selectedColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: selectedIcon)
                    .font(.system(size: 34))
                    .foregroundColor(selectedColor)
            }
            Text(name.isEmpty ? "Room Name" : name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(name.isEmpty ? .secondary : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.systemGray6).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Room Name", systemImage: "textformat")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            TextField("e.g. Living Room", text: $name)
                .padding(14)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Choose Icon & Color", systemImage: "paintpalette")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            let cols = [GridItem](repeating: GridItem(.flexible(), spacing: 12), count: 4)
            LazyVGrid(columns: cols, spacing: 12) {
                ForEach(HomeRoom.iconOptions, id: \.0) { option in
                    iconOption(icon: option.0, color: option.1)
                }
            }
        }
    }

    private func iconOption(icon: String, color: Color) -> some View {
        let isSelected = selectedIcon == icon
        return Button(action: { selectedIcon = icon; selectedColor = color }) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? color : Color(.systemGray6))
                    .frame(height: 56)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .white : color)
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(isSelected ? color : Color.clear, lineWidth: 2))
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let room = HomeRoom(name: trimmed, icon: selectedIcon, color: selectedColor)
        homeStore.addRoom(room)
        isPresented = false
    }
}

struct EditRoomSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    let room: HomeRoom
    @Binding var isPresented: Bool
    @State private var name: String
    @State private var selectedIcon: String
    @State private var selectedColor: Color

    init(room: HomeRoom, isPresented: Binding<Bool>) {
        self.room = room
        self._isPresented = isPresented
        self._name = State(initialValue: room.name)
        self._selectedIcon = State(initialValue: room.icon)
        self._selectedColor = State(initialValue: room.color)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    previewCard
                    nameSection
                    iconSection
                }
                .padding(20)
            }
            .navigationTitle("Edit Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private var previewCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(selectedColor.opacity(0.15)).frame(width: 80, height: 80)
                Image(systemName: selectedIcon).font(.system(size: 34)).foregroundColor(selectedColor)
            }
            Text(name.isEmpty ? "Room Name" : name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(name.isEmpty ? .secondary : .primary)
        }
        .frame(maxWidth: .infinity).padding(24)
        .background(Color(.systemGray6).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Room Name", systemImage: "textformat").font(.subheadline.weight(.semibold)).foregroundColor(.secondary)
            TextField("e.g. Living Room", text: $name)
                .padding(14).background(Color(.systemGray6)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Choose Icon & Color", systemImage: "paintpalette").font(.subheadline.weight(.semibold)).foregroundColor(.secondary)
            let cols = [GridItem](repeating: GridItem(.flexible(), spacing: 12), count: 4)
            LazyVGrid(columns: cols, spacing: 12) {
                ForEach(HomeRoom.iconOptions, id: \.0) { option in
                    iconOption(icon: option.0, color: option.1)
                }
            }
        }
    }

    private func iconOption(icon: String, color: Color) -> some View {
        let isSelected = selectedIcon == icon
        return Button(action: { selectedIcon = icon; selectedColor = color }) {
            ZStack {
                RoundedRectangle(cornerRadius: 14).fill(isSelected ? color : Color(.systemGray6)).frame(height: 56)
                Image(systemName: icon).font(.system(size: 22)).foregroundColor(isSelected ? .white : color)
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(isSelected ? color : Color.clear, lineWidth: 2))
        }
    }

    private func save() {
        var updated = room
        updated.name = name.trimmingCharacters(in: .whitespaces)
        updated.icon = selectedIcon
        updated.color = selectedColor
        homeStore.updateRoom(updated)
        isPresented = false
    }
}
