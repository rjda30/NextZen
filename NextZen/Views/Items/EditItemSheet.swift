import SwiftUI

struct EditItemSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    let item: HomeItem
    @Binding var isPresented: Bool

    @State private var name: String
    @State private var brand: String
    @State private var model: String
    @State private var serial: String
    @State private var notes: String
    @State private var selectedCategory: ItemCategory
    @State private var selectedRoomId: UUID?
    @State private var hasWarranty: Bool
    @State private var warrantyDate: Date

    init(item: HomeItem, isPresented: Binding<Bool>) {
        self.item = item
        self._isPresented = isPresented
        self._name = State(initialValue: item.name)
        self._brand = State(initialValue: item.brand)
        self._model = State(initialValue: item.model)
        self._serial = State(initialValue: item.serialNumber)
        self._notes = State(initialValue: item.notes)
        self._selectedCategory = State(initialValue: ItemCategory(rawValue: item.category) ?? .other)
        self._selectedRoomId = State(initialValue: item.roomId)
        self._hasWarranty = State(initialValue: item.warrantyExpires != nil)
        self._warrantyDate = State(initialValue: item.warrantyExpires ?? Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Item Info") {
                    HStack {
                        Image(systemName: selectedCategory.icon).foregroundColor(.blue).frame(width: 24)
                        TextField("Item Name *", text: $name)
                    }
                    HStack {
                        Image(systemName: "tag.fill").foregroundColor(.orange).frame(width: 24)
                        TextField("Brand", text: $brand)
                    }
                    HStack {
                        Image(systemName: "number").foregroundColor(.purple).frame(width: 24)
                        TextField("Model", text: $model)
                    }
                }
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ItemCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("Room") {
                    Picker("Room", selection: $selectedRoomId) {
                        ForEach(homeStore.rooms) { room in
                            Label(room.name, systemImage: room.icon).tag(Optional(room.id))
                        }
                    }
                    .pickerStyle(.menu)
                }
                Section("Details") {
                    HStack {
                        Image(systemName: "barcode").foregroundColor(.gray).frame(width: 24)
                        TextField("Serial Number", text: $serial)
                    }
                    HStack {
                        Image(systemName: "note.text").foregroundColor(.teal).frame(width: 24)
                        TextField("Notes", text: $notes)
                    }
                }
                Section("Warranty") {
                    Toggle(isOn: $hasWarranty) {
                        Label("Has Warranty", systemImage: "checkmark.shield.fill")
                    }
                    if hasWarranty {
                        DatePicker("Expires", selection: $warrantyDate, displayedComponents: .date)
                    }
                }
                Section {
                    Button(role: .destructive) {
                        homeStore.deleteItem(id: item.id)
                        isPresented = false
                    } label: {
                        Label("Delete Item", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { isPresented = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        var updated = item
        updated.name = name.trimmingCharacters(in: .whitespaces)
        updated.brand = brand
        updated.model = model
        updated.serialNumber = serial
        updated.notes = notes
        updated.category = selectedCategory.rawValue
        updated.icon = selectedCategory.icon
        updated.roomId = selectedRoomId
        updated.warrantyExpires = hasWarranty ? warrantyDate : nil
        homeStore.updateItem(updated)
        isPresented = false
    }
}

struct AddDocumentSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    let itemId: UUID
    @Binding var isPresented: Bool
    @State private var docName = ""
    @State private var docType = HomeDocument.DocType.manual

    var body: some View {
        NavigationStack {
            Form {
                Section("Document Info") {
                    TextField("Document Name", text: $docName)
                    Picker("Type", selection: $docType) {
                        ForEach(HomeDocument.DocType.allCases, id: \.self) { t in
                            Label(t.rawValue, systemImage: t.icon).tag(t)
                        }
                    }
                }
                Section {
                    Button(action: {
                        Label("Upload from Files", systemImage: "folder.fill")
                    }) {
                        Label("Browse Files", systemImage: "folder").foregroundColor(.blue)
                    }
                    Button(action: {}) {
                        Label("Take Photo", systemImage: "camera").foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Add Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { isPresented = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveDoc() }.fontWeight(.semibold)
                        .disabled(docName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveDoc() {
        let doc = HomeDocument(name: docName, type: docType)
        for rIdx in homeStore.rooms.indices {
            if let iIdx = homeStore.rooms[rIdx].items.firstIndex(where: { $0.id == itemId }) {
                homeStore.rooms[rIdx].items[iIdx].documents.append(doc)
                break
            }
        }
        isPresented = false
    }
}

struct AddReminderSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    let itemId: UUID?
    let itemName: String
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var isUrgent = false

    private let suggestions = ["Replace Filter", "Battery Check", "Clean Unit", "Inspect Seals", "Service Appointment", "Warranty Reminder"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Reminder Details") {
                    TextField("Reminder Title", text: $title)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    Toggle(isOn: $isUrgent) { Label("Mark as Urgent", systemImage: "exclamationmark.triangle.fill") }
                }
                Section("Quick Templates") {
                    ForEach(suggestions, id: \.self) { s in
                        Button(action: { title = s }) {
                            Text(s).foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Add Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { isPresented = false } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }.fontWeight(.semibold)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let reminder = MaintenanceReminder(
            title: title, dueDate: dueDate, isUrgent: isUrgent,
            itemId: itemId, itemName: itemName, icon: "bell.fill"
        )
        homeStore.addReminder(reminder)
        isPresented = false
    }
}
