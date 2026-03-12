import Foundation
import Supabase
import SwiftUI

// MARK: - Codable DTOs for Supabase
struct RoomDTO: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let name: String
    let icon: String
    let colorHex: String
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case userId = "user_id"
        case colorHex = "color_hex"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct RoomInsert: Codable {
    let id: String
    let userId: String
    let name: String
    let icon: String
    let colorHex: String

    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case userId = "user_id"
        case colorHex = "color_hex"
    }
}

struct ItemDTO: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let roomId: UUID?
    let name: String
    let category: String
    let brand: String
    let model: String
    let serialNumber: String
    let notes: String
    let icon: String
    let warrantyExpires: Date?
    let barcode: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, category, brand, model, notes, icon, barcode
        case userId = "user_id"
        case roomId = "room_id"
        case serialNumber = "serial_number"
        case warrantyExpires = "warranty_expires"
        case createdAt = "created_at"
    }
}

struct ItemInsert: Codable {
    let id: String
    let userId: String
    let roomId: String?
    let name: String
    let category: String
    let brand: String
    let model: String
    let serialNumber: String
    let notes: String
    let icon: String
    let warrantyExpires: Date?
    let barcode: String?

    enum CodingKeys: String, CodingKey {
        case id, name, category, brand, model, notes, icon, barcode
        case userId = "user_id"
        case roomId = "room_id"
        case serialNumber = "serial_number"
        case warrantyExpires = "warranty_expires"
    }
}

struct ReminderDTO: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let itemId: UUID?
    let title: String
    let dueDate: Date
    let isCompleted: Bool
    let isUrgent: Bool
    let itemName: String
    let icon: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title, icon
        case userId = "user_id"
        case itemId = "item_id"
        case dueDate = "due_date"
        case isCompleted = "is_completed"
        case isUrgent = "is_urgent"
        case itemName = "item_name"
        case createdAt = "created_at"
    }
}

struct ReminderInsert: Codable {
    let id: String
    let userId: String
    let title: String
    let dueDate: Date
    let isCompleted: Bool
    let isUrgent: Bool
    let itemName: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, title, icon
        case userId = "user_id"
        case dueDate = "due_date"
        case isCompleted = "is_completed"
        case isUrgent = "is_urgent"
        case itemName = "item_name"
    }
}

// MARK: - SyncService
@MainActor
final class SyncService {
    static let shared = SyncService()
    private init() {}

    // MARK: Rooms
    func fetchRooms(userId: UUID) async throws -> [RoomDTO] {
        try await supabase.from("rooms")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at")
            .execute()
            .value
    }

    func upsertRoom(_ room: HomeRoom, userId: UUID) async throws {
        let dto = RoomInsert(
            id: room.id.uuidString,
            userId: userId.uuidString,
            name: room.name,
            icon: room.icon,
            colorHex: room.color.toHex()
        )
        try await supabase.from("rooms").upsert(dto, onConflict: "id").execute()
    }

    func deleteRoom(id: UUID, userId: UUID) async throws {
        try await supabase.from("rooms")
            .delete()
            .eq("id", value: id.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }

    // MARK: Items
    func fetchItems(userId: UUID) async throws -> [ItemDTO] {
        try await supabase.from("items")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at")
            .execute()
            .value
    }

    func upsertItem(_ item: HomeItem, userId: UUID) async throws {
        let dto = ItemInsert(
            id: item.id.uuidString,
            userId: userId.uuidString,
            roomId: item.roomId?.uuidString,
            name: item.name,
            category: item.category,
            brand: item.brand,
            model: item.model,
            serialNumber: item.serialNumber,
            notes: item.notes,
            icon: item.icon,
            warrantyExpires: item.warrantyExpires,
            barcode: item.barcode
        )
        try await supabase.from("items").upsert(dto, onConflict: "id").execute()
    }

    func deleteItem(id: UUID, userId: UUID) async throws {
        try await supabase.from("items")
            .delete()
            .eq("id", value: id.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }

    // MARK: Reminders
    func fetchReminders(userId: UUID) async throws -> [ReminderDTO] {
        try await supabase.from("reminders")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("due_date")
            .execute()
            .value
    }

    func upsertReminder(_ reminder: MaintenanceReminder, userId: UUID) async throws {
        let dto = ReminderInsert(
            id: reminder.id.uuidString,
            userId: userId.uuidString,
            title: reminder.title,
            dueDate: reminder.dueDate,
            isCompleted: reminder.isCompleted,
            isUrgent: reminder.isUrgent,
            itemName: reminder.itemName,
            icon: reminder.icon
        )
        try await supabase.from("reminders").upsert(dto, onConflict: "id").execute()
    }

    func deleteReminder(id: UUID, userId: UUID) async throws {
        try await supabase.from("reminders")
            .delete()
            .eq("id", value: id.uuidString)
            .eq("user_id", value: userId.uuidString)
            .execute()
    }
}

// MARK: - Color Extension
extension Color {
    func toHex() -> String {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
