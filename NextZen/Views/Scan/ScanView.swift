import SwiftUI

struct ScanView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: HomeStore
    @State private var showBarcodeScanner = false
    @State private var showAddItem = false
    @State private var scannedBarcode: String? = nil

    private let accent = Color(hex: "1A6BFF")
    private let orange = Color(hex: "FF6B2B")

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                VStack(spacing: 0) {
                    scanIllustration
                    actionCards
                    Spacer()
                }
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .fullScreenCover(isPresented: $showBarcodeScanner) {
            BarcodeScannerSheet { code in
                scannedBarcode = code
                showAddItem = true
            }
        }
        .sheet(isPresented: $showAddItem) {
            AddItemSheet(
                preselectedRoomId: nil,
                isPresented: $showAddItem,
                prefillBarcode: scannedBarcode
            )
            .environmentObject(store)
            .onDisappear { scannedBarcode = nil }
        }
    }

    private var scanIllustration: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.08))
                    .frame(width: 140, height: 140)
                Circle()
                    .fill(accent.opacity(0.14))
                    .frame(width: 100, height: 100)
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 52))
                    .foregroundStyle(
                        LinearGradient(colors: [accent, Color(hex: "0049CC")],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            .padding(.top, 48)

            VStack(spacing: 8) {
                Text("Scan to Add Items")
                    .font(.system(size: 24, weight: .bold))
                Text("Use your camera to scan barcodes\nand quickly add items to your home.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 40)
    }

    private var actionCards: some View {
        VStack(spacing: 14) {
            Button(action: { showBarcodeScanner = true }) {
                ScanOptionCard(
                    icon: "barcode.viewfinder",
                    iconColor: accent,
                    title: "Scan Barcode",
                    subtitle: "EAN-13, QR, Code128 & more",
                    badge: nil
                )
            }
            .buttonStyle(.plain)

            Button(action: { showAddItem = true }) {
                ScanOptionCard(
                    icon: "pencil.and.list.clipboard",
                    iconColor: orange,
                    title: "Add Manually",
                    subtitle: "Enter item details by hand",
                    badge: nil
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
    }
}

private struct ScanOptionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let badge: String?

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(iconColor)
                .frame(width: 52, height: 52)
                .background(iconColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 7).padding(.vertical, 3)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                }
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(18)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
