import Foundation
import SwiftUI
import Supabase

// MARK: - Core Models

struct HomeRoom: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var icon: String
    var color: Color
    var items: [HomeItem] = []

    var itemCount: Int { items.count }

    static let iconOptions: [(String, Color)] = [
        ("sofa.fill", .blue), ("refrigerator.fill", .orange), ("bed.double.fill", .purple),
        ("shower.fill", .teal), ("car.fill", .gray), ("desktopcomputer", .indigo),
        ("washer.fill", .cyan), ("fork.knife", .red), ("house.fill", .green),
        ("door.garage.closed", .brown), ("backpack.fill", .pink), ("tree.fill", .mint)
    ]
}

struct HomeItem: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var category: String
    var brand: String
    var model: String
    var serialNumber: String
    var notes: String
    var icon: String
    var roomId: UUID?
    var warrantyExpires: Date?
    var purchaseDate: Date?
    var barcode: String? = nil
    var documents: [HomeDocument] = []
    var reminders: [MaintenanceReminder] = []
    var createdAt: Date = Date()
}

struct HomeDocument: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var type: DocType
    var dateAdded: Date = Date()

    enum DocType: String, CaseIterable {
        case manual = "Manual"
        case receipt = "Receipt"
        case warranty = "Warranty"
        case other = "Other"

        var icon: String {
            switch self {
            case .manual: return "book.fill"
            case .receipt: return "receipt.fill"
            case .warranty: return "checkmark.shield.fill"
            case .other: return "doc.fill"
            }
        }
    }
}

struct MaintenanceReminder: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
    var isUrgent: Bool = false
    var itemId: UUID?
    var itemName: String
    var icon: String
}

// MARK: - Category Options
enum ItemCategory: String, CaseIterable {
    case electronics = "Electronics"
    case appliance = "Appliance"
    case furniture = "Furniture"
    case smartHome = "Smart Home"
    case plumbing = "Plumbing"
    case hvac = "HVAC"
    case lighting = "Lighting"
    case other = "Other"

    var icon: String {
        switch self {
        case .electronics: return "tv.fill"
        case .appliance: return "refrigerator.fill"
        case .furniture: return "sofa.fill"
        case .smartHome: return "homekit"
        case .plumbing: return "shower.fill"
        case .hvac: return "wind"
        case .lighting: return "lightbulb.fill"
        case .other: return "cube.fill"
        }
    }
}

// MARK: - HomeStore (Single Source of Truth)
final class HomeStore: ObservableObject {
    @Published var rooms: [HomeRoom] = HomeStore.sampleRooms()
    @Published var reminders: [MaintenanceReminder] = HomeStore.sampleReminders()
    @Published var homeName: String = "My Apartment"
    @Published var isSyncing = false
    @Published var syncError: String? = nil

    // MARK: Supabase Sync
    @MainActor
    func syncFromSupabase(userId: UUID) async {
        isSyncing = true
        syncError = nil
        do {
            let remotRooms = try await SyncService.shared.fetchRooms(userId: userId)
            let remoteItems = try await SyncService.shared.fetchItems(userId: userId)
            let remoteReminders = try await SyncService.shared.fetchReminders(userId: userId)

            var builtRooms: [HomeRoom] = remotRooms.map { dto in
                HomeRoom(id: dto.id, name: dto.name, icon: dto.icon, color: Color(hex: dto.colorHex))
            }
            for item in remoteItems {
                let homeItem = HomeItem(
                    id: item.id,
                    name: item.name,
                    category: item.category,
                    brand: item.brand,
                    model: item.model,
                    serialNumber: item.serialNumber,
                    notes: item.notes,
                    icon: item.icon,
                    roomId: item.roomId,
                    warrantyExpires: item.warrantyExpires,
                    barcode: item.barcode,
                    createdAt: item.createdAt
                )
                if let rIdx = builtRooms.firstIndex(where: { $0.id == item.roomId }) {
                    builtRooms[rIdx].items.append(homeItem)
                }
            }
            rooms = builtRooms.isEmpty ? HomeStore.sampleRooms() : builtRooms
            reminders = remoteReminders.map { dto in
                MaintenanceReminder(
                    id: dto.id,
                    title: dto.title,
                    dueDate: dto.dueDate,
                    isCompleted: dto.isCompleted,
                    isUrgent: dto.isUrgent,
                    itemName: dto.itemName,
                    icon: dto.icon
                )
            }
        } catch {
            syncError = error.localizedDescription
        }
        isSyncing = false
    }

    func pushRoom(_ room: HomeRoom, userId: UUID) {
        Task { try? await SyncService.shared.upsertRoom(room, userId: userId) }
    }

    func pushItem(_ item: HomeItem, userId: UUID) {
        Task { try? await SyncService.shared.upsertItem(item, userId: userId) }
    }

    func pushReminder(_ reminder: MaintenanceReminder, userId: UUID) {
        Task { try? await SyncService.shared.upsertReminder(reminder, userId: userId) }
    }

    func removeRoomRemote(id: UUID, userId: UUID) {
        Task { try? await SyncService.shared.deleteRoom(id: id, userId: userId) }
    }

    func removeItemRemote(id: UUID, userId: UUID) {
        Task { try? await SyncService.shared.deleteItem(id: id, userId: userId) }
    }

    var allItems: [HomeItem] {
        rooms.flatMap { $0.items }
    }

    func room(for item: HomeItem) -> HomeRoom? {
        rooms.first { $0.id == item.roomId }
    }

    // MARK: Room Operations
    func addRoom(_ room: HomeRoom) {
        rooms.append(room)
    }

    func updateRoom(_ room: HomeRoom) {
        if let idx = rooms.firstIndex(where: { $0.id == room.id }) {
            rooms[idx] = room
        }
    }

    func deleteRoom(id: UUID) {
        rooms.removeAll { $0.id == id }
    }

    // MARK: Item Operations
    func addItem(_ item: HomeItem, toRoomId roomId: UUID) {
        var newItem = item
        newItem.roomId = roomId
        if let idx = rooms.firstIndex(where: { $0.id == roomId }) {
            rooms[idx].items.append(newItem)
        }
    }

    func updateItem(_ item: HomeItem) {
        for rIdx in rooms.indices {
            if let iIdx = rooms[rIdx].items.firstIndex(where: { $0.id == item.id }) {
                rooms[rIdx].items[iIdx] = item
                return
            }
        }
    }

    func deleteItem(id: UUID) {
        for rIdx in rooms.indices {
            rooms[rIdx].items.removeAll { $0.id == id }
        }
    }

    // MARK: Reminder Operations
    func addReminder(_ reminder: MaintenanceReminder) {
        reminders.append(reminder)
    }

    func toggleReminder(id: UUID) {
        if let idx = reminders.firstIndex(where: { $0.id == id }) {
            reminders[idx].isCompleted.toggle()
        }
    }

    func deleteReminder(id: UUID) {
        reminders.removeAll { $0.id == id }
    }

    var activeReminders: [MaintenanceReminder] {
        reminders.filter { !$0.isCompleted }.sorted { $0.dueDate < $1.dueDate }
    }

    var urgentCount: Int {
        activeReminders.filter { $0.isUrgent || $0.dueDate < Date().addingTimeInterval(86400 * 3) }.count
    }

    // MARK: Sample Data
    static func sampleRooms() -> [HomeRoom] {
        var kitchen = HomeRoom(name: "Kitchen", icon: "refrigerator.fill", color: .orange)
        kitchen.items = [
            HomeItem(name: "KitchenAid Mixer", category: "Appliance", brand: "KitchenAid", model: "KSM150PS", serialNumber: "KA-2021-8831", notes: "5-quart tilt-head", icon: "blender.fill", roomId: kitchen.id, warrantyExpires: Calendar.current.date(byAdding: .year, value: 2, to: Date())),
            HomeItem(name: "Bosch Dishwasher", category: "Appliance", brand: "Bosch", model: "SHPM88Z75N", serialNumber: "BSH-1122-4455", notes: "", icon: "dishwasher.fill", roomId: kitchen.id, warrantyExpires: Calendar.current.date(byAdding: .month, value: 18, to: Date()))
        ]

        var living = HomeRoom(name: "Living Room", icon: "sofa.fill", color: .blue)
        living.items = [
            HomeItem(name: "Samsung TV 65\"", category: "Electronics", brand: "Samsung", model: "QN65S95C", serialNumber: "SG-TV-9900", notes: "Wall mounted", icon: "tv.fill", roomId: living.id, warrantyExpires: Calendar.current.date(byAdding: .month, value: 8, to: Date())),
            HomeItem(name: "Dyson V15", category: "Appliance", brand: "Dyson", model: "V15 Detect", serialNumber: "DY-V15-5678", notes: "", icon: "fan.fill", roomId: living.id, warrantyExpires: Calendar.current.date(byAdding: .month, value: 3, to: Date())),
            HomeItem(name: "Nest Thermostat", category: "Smart Home", brand: "Google", model: "4th Gen", serialNumber: "NT-GG-0012", notes: "Set to 72°F default", icon: "thermometer.medium", roomId: living.id)
        ]

        var bedroom = HomeRoom(name: "Bedroom", icon: "bed.double.fill", color: .purple)
        bedroom.items = [
            HomeItem(name: "Casper Mattress", category: "Furniture", brand: "Casper", model: "Wave Hybrid", serialNumber: "", notes: "King size", icon: "bed.double.fill", roomId: bedroom.id, warrantyExpires: Calendar.current.date(byAdding: .year, value: 8, to: Date()))
        ]

        let bathroom = HomeRoom(name: "Bathroom", icon: "shower.fill", color: .teal)
        let garage = HomeRoom(name: "Garage", icon: "car.fill", color: .gray)
        return [kitchen, living, bedroom, bathroom, garage]
    }

    static func sampleReminders() -> [MaintenanceReminder] {
        [
            MaintenanceReminder(title: "HVAC Filter Change", dueDate: Date().addingTimeInterval(86400), isUrgent: true, itemName: "HVAC System", icon: "wind"),
            MaintenanceReminder(title: "Smoke Detector Battery", dueDate: Date().addingTimeInterval(86400 * 3), isUrgent: true, itemName: "Smoke Detector", icon: "flame.fill"),
            MaintenanceReminder(title: "Dishwasher Cleaning Cycle", dueDate: Date().addingTimeInterval(86400 * 7), isUrgent: false, itemName: "Bosch Dishwasher", icon: "dishwasher.fill"),
            MaintenanceReminder(title: "Dyson Filter Clean", dueDate: Date().addingTimeInterval(86400 * 14), isUrgent: false, itemName: "Dyson V15", icon: "fan.fill")
        ]
    }

    var categoryDistribution: [(String, Double, Color)] {
        let categories = allItems.map { $0.category }
        var counts: [String: Int] = [:]
        for c in categories { counts[c, default: 0] += 1 }
        let total = Double(max(allItems.count, 1))
        let colorMap: [String: Color] = [
            "Electronics": .blue, "Appliance": .orange, "Furniture": .purple,
            "Smart Home": .teal, "HVAC": .cyan, "Other": .gray
        ]
        return counts.map { (key, val) in
            (key, Double(val) / total * 100, colorMap[key] ?? .indigo)
        }.sorted { $0.1 > $1.1 }
    }
}
