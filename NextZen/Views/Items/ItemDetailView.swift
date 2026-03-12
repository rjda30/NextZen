import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var homeStore: HomeStore
    let item: HomeItem
    @State private var showEdit = false
    @State private var showAddReminder = false
    @State private var showAddDoc = false
    @Environment(\.dismiss) var dismiss

    private var currentItem: HomeItem {
        homeStore.allItems.first { $0.id == item.id } ?? item
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                heroCard
                infoGrid
                if !currentItem.documents.isEmpty { documentsSection }
                remindersSection
                actionsSection
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .background(Color(.systemGray6).opacity(0.5))
        .navigationTitle(currentItem.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showEdit = true }) {
                    Text("Edit").fontWeight(.medium)
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditItemSheet(item: currentItem, isPresented: $showEdit)
                .environmentObject(homeStore)
        }
        .sheet(isPresented: $showAddReminder) {
            AddReminderSheet(itemId: currentItem.id, itemName: currentItem.name, isPresented: $showAddReminder)
                .environmentObject(homeStore)
        }
        .sheet(isPresented: $showAddDoc) {
            AddDocumentSheet(itemId: currentItem.id, isPresented: $showAddDoc)
                .environmentObject(homeStore)
        }
    }

    private var heroCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(hex: "6C63FF").opacity(0.15), Color(hex: "3B82F6").opacity(0.1)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 90, height: 90)
                Image(systemName: currentItem.icon)
                    .font(.system(size: 38))
                    .foregroundColor(Color(hex: "6C63FF"))
            }
            VStack(spacing: 4) {
                Text(currentItem.name).font(.title2.bold())
                if !currentItem.brand.isEmpty {
                    Text(currentItem.brand).font(.subheadline).foregroundColor(.secondary)
                }
            }
            categoryWarrantyPills
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private var categoryWarrantyPills: some View {
        HStack(spacing: 8) {
            pillTag(text: currentItem.category, color: .blue)
            if let room = homeStore.room(for: currentItem) {
                pillTag(text: room.name, color: room.color)
            }
            if let exp = currentItem.warrantyExpires {
                let days = Calendar.current.dateComponents([.day], from: Date(), to: exp).day ?? 0
                pillTag(text: days > 0 ? "Warranty: \(days)d" : "Expired", color: days > 0 ? .green : .red)
            }
        }
    }

    private func pillTag(text: String, color: Color) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .clipShape(Capsule())
    }

    private var infoGrid: some View {
        VStack(spacing: 0) {
            if !currentItem.model.isEmpty { infoRow(label: "Model", value: currentItem.model, icon: "number") }
            if !currentItem.serialNumber.isEmpty { infoRow(label: "Serial", value: currentItem.serialNumber, icon: "barcode") }
            if let d = currentItem.purchaseDate { infoRow(label: "Purchased", value: d.formatted(date: .abbreviated, time: .omitted), icon: "calendar") }
            if !currentItem.notes.isEmpty { infoRow(label: "Notes", value: currentItem.notes, icon: "note.text") }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private func infoRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.subheadline).foregroundColor(.secondary).frame(width: 22)
            Text(label).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            Text(value).font(.subheadline.weight(.medium)).multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16).padding(.vertical, 13)
        .overlay(alignment: .bottom) {
            Divider().padding(.leading, 50)
        }
    }

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Documents", action: ("Add", { showAddDoc = true }))
            ForEach(currentItem.documents) { doc in
                docRow(doc: doc)
            }
        }
    }

    private var remindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Reminders", action: ("Add", { showAddReminder = true }))
            let itemReminders = homeStore.reminders.filter { $0.itemId == currentItem.id }
            if itemReminders.isEmpty {
                emptyRemindersCard
            } else {
                ForEach(itemReminders) { r in reminderRow(r) }
            }
        }
    }

    private func sectionHeader(title: String, action: (String, () -> Void)) -> some View {
        HStack {
            Text(title).font(.system(size: 18, weight: .bold))
            Spacer()
            Button(action: action.1) {
                Label(action.0, systemImage: "plus")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.black.opacity(0.07))
                    .clipShape(Capsule())
            }
            .foregroundColor(.primary)
        }
    }

    private func docRow(doc: HomeDocument) -> some View {
        HStack(spacing: 12) {
            Image(systemName: doc.type.icon).font(.body).foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(hex: "6C63FF"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(doc.name).font(.system(size: 14, weight: .medium))
                Text(doc.type.rawValue).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "arrow.down.circle").foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private func reminderRow(_ r: MaintenanceReminder) -> some View {
        HStack(spacing: 12) {
            Image(systemName: r.icon).font(.body).foregroundColor(r.isUrgent ? .white : .orange)
                .frame(width: 40, height: 40)
                .background(r.isUrgent ? Color.red : Color.orange.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(r.title).font(.system(size: 14, weight: .medium))
                Text(r.dueDate.formatted(date: .abbreviated, time: .omitted)).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Button(action: { homeStore.toggleReminder(id: r.id) }) {
                Image(systemName: r.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(r.isCompleted ? .green : .secondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
    }

    private var emptyRemindersCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.slash").foregroundColor(.secondary)
            Text("No reminders set").font(.subheadline).foregroundColor(.secondary)
            Spacer()
            Button(action: { showAddReminder = true }) {
                Text("Add").font(.caption.weight(.semibold)).padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color.black).foregroundColor(.white).clipShape(Capsule())
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var actionsSection: some View {
        VStack(spacing: 10) {
            actionButton(label: "Upload Manual", icon: "book.fill", color: Color(hex: "6C63FF")) { showAddDoc = true }
            actionButton(label: "Upload Receipt", icon: "receipt.fill", color: Color(hex: "F59E0B")) { showAddDoc = true }
            actionButton(label: "Set Maintenance Reminder", icon: "bell.badge.fill", color: Color(hex: "34D399")) { showAddReminder = true }
        }
    }

    private func actionButton(label: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.body).foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(label).font(.system(size: 15, weight: .medium)).foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        }
    }
}
