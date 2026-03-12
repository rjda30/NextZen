import SwiftUI

struct AddItemSheet: View {
    @EnvironmentObject var homeStore: HomeStore
    let preselectedRoomId: UUID?
    @Binding var isPresented: Bool
    var prefillBarcode: String? = nil

    @State private var name = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var serial = ""
    @State private var notes = ""
    @State private var barcode = ""
    @State private var selectedCategory = ItemCategory.electronics
    @State private var selectedRoomId: UUID? = nil
    @State private var hasWarranty = false
    @State private var warrantyDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var showBarcodeScanner = false

    var body: some View {
        NavigationStack {
            Form {
                basicInfoSection
                categorySection
                roomSection
                barcodeSection
                detailsSection
                warrantySection
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || selectedRoomId == nil)
                }
            }
            .onAppear {
                selectedRoomId = preselectedRoomId ?? homeStore.rooms.first?.id
                if let code = prefillBarcode { barcode = code }
            }
        }
        .fullScreenCover(isPresented: $showBarcodeScanner) {
            BarcodeScannerSheet { code in
                barcode = code
            }
        }
    }

    private var basicInfoSection: some View {
        Section("Item Info") {
            HStack {
                Image(systemName: selectedCategory.icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
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
    }

    private var categorySection: some View {
        Section("Category") {
            Picker("Category", selection: $selectedCategory) {
                ForEach(ItemCategory.allCases, id: \.self) { cat in
                    Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var roomSection: some View {
        Section("Assign to Room") {
            Picker("Room", selection: $selectedRoomId) {
                ForEach(homeStore.rooms) { room in
                    Label(room.name, systemImage: room.icon).tag(Optional(room.id))
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var barcodeSection: some View {
        Section("Barcode") {
            HStack {
                Image(systemName: "barcode").foregroundColor(.gray).frame(width: 24)
                TextField("Barcode", text: $barcode)
                if !barcode.isEmpty {
                    Button(action: { barcode = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }
                    .buttonStyle(.borderless)
                }
            }
            Button(action: { showBarcodeScanner = true }) {
                Label(barcode.isEmpty ? "Scan Barcode" : "Re-scan Barcode",
                      systemImage: "barcode.viewfinder")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "1A6BFF"))
            }
        }
    }

    private var detailsSection: some View {
        Section("Additional Details") {
            HStack {
                Image(systemName: "creditcard.fill").foregroundColor(.gray).frame(width: 24)
                TextField("Serial Number", text: $serial)
            }
            HStack {
                Image(systemName: "note.text").foregroundColor(.teal).frame(width: 24)
                TextField("Notes", text: $notes)
            }
        }
    }

    private var warrantySection: some View {
        Section("Warranty") {
            Toggle(isOn: $hasWarranty) {
                Label("Has Warranty", systemImage: "checkmark.shield.fill")
            }
            if hasWarranty {
                DatePicker("Expires", selection: $warrantyDate, displayedComponents: .date)
            }
        }
    }

    private func save() {
        guard let roomId = selectedRoomId else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let item = HomeItem(
            name: trimmed,
            category: selectedCategory.rawValue,
            brand: brand,
            model: model,
            serialNumber: serial,
            notes: notes,
            icon: selectedCategory.icon,
            roomId: roomId,
            warrantyExpires: hasWarranty ? warrantyDate : nil,
            barcode: barcode.isEmpty ? nil : barcode
        )
        homeStore.addItem(item, toRoomId: roomId)
        isPresented = false
    }
}
