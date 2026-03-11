import SwiftUI

struct ScanView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: HomeStore
    @State private var isScanning = false
    @State private var showAddItem = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    cameraFrame
                    controlsPanel
                }
            }
            .navigationTitle("Scan Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showAddItem) {
            AddItemSheet(preselectedRoomId: nil, isPresented: $showAddItem)
                .environmentObject(store)
        }
    }

    private var cameraFrame: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 380)
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                .frame(width: 260, height: 260)
                .overlay(cornerMarkers)
            if isScanning {
                scanLineAnimation
            } else {
                scanPrompt
            }
        }
    }

    private var cornerMarkers: some View {
        ZStack {
            ForEach([(0.0, 0.0), (1.0, 0.0), (0.0, 1.0), (1.0, 1.0)], id: \.0) { x, y in
                RoundedCornerMark()
                    .frame(width: 260, height: 260)
                    .scaleEffect(x: x == 0 ? 1 : -1, y: y == 0 ? 1 : -1)
            }
        }
    }

    private var scanPrompt: some View {
        VStack(spacing: 12) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.6))
            Text("Point camera at barcode\nor item")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }

    private var scanLineAnimation: some View {
        Rectangle()
            .fill(LinearGradient(colors: [.clear, .blue, .clear], startPoint: .leading, endPoint: .trailing))
            .frame(height: 2)
            .padding(.horizontal, 8)
    }

    private var controlsPanel: some View {
        VStack(spacing: 24) {
            Text(isScanning ? "Scanning…" : "Ready to scan")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 24)

            Button(action: simulateScan) {
                HStack(spacing: 10) {
                    Image(systemName: isScanning ? "stop.circle.fill" : "barcode.viewfinder")
                        .font(.title3)
                    Text(isScanning ? "Stop" : "Scan Barcode")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.white)
                .clipShape(Capsule())
            }

            Button(action: simulatePhotoCapture) {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.title3)
                    Text("Capture Photo")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.15))
                .clipShape(Capsule())
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    private func simulateScan() {
        isScanning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isScanning = false
            showAddItem = true
        }
    }

    private func simulatePhotoCapture() {
        showAddItem = true
    }
}

private struct RoundedCornerMark: View {
    var body: some View {
        Canvas { context, size in
            let len: CGFloat = 20
            let t: CGFloat = 3
            var path = Path()
            path.move(to: CGPoint(x: 0, y: len))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: len, y: 0))
            context.stroke(path, with: .color(.blue), lineWidth: t)
        }
    }
}
