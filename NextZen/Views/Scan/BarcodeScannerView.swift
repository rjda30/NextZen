import SwiftUI
import AVFoundation

// MARK: - UIKit Barcode Scanner
final class BarcodeScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var onFound: (String) -> Void
    init(onFound: @escaping (String) -> Void) { self.onFound = onFound }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput objects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let obj = objects.first as? AVMetadataMachineReadableCodeObject,
              let value = obj.stringValue else { return }
        DispatchQueue.main.async { self.onFound(value) }
    }
}

struct BarcodeCameraView: UIViewRepresentable {
    let onBarcodeFound: (String) -> Void
    @Binding var isActive: Bool

    func makeCoordinator() -> BarcodeScannerCoordinator {
        BarcodeScannerCoordinator(onFound: onBarcodeFound)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        setupSession(in: view, coordinator: context.coordinator)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func setupSession(in view: UIView, coordinator: BarcodeScannerCoordinator) {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        let session = AVCaptureSession()
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(coordinator, queue: .main)
        output.metadataObjectTypes = [
            .ean8, .ean13, .pdf417, .qr, .code128, .code39, .upce, .interleaved2of5
        ]

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)

        DispatchQueue.main.async {
            preview.frame = view.bounds
        }
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        // store session ref for layout
        view.tag = 999
        objc_setAssociatedObject(view, &AssociatedKeys.previewLayer, preview, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(view, &AssociatedKeys.captureSession, session, .OBJC_ASSOCIATION_RETAIN)
    }
}

private enum AssociatedKeys {
    static var previewLayer = "previewLayer"
    static var captureSession = "captureSession"
}

// MARK: - SwiftUI Barcode Scanner Sheet
struct BarcodeScannerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onBarcodeFound: (String) -> Void

    @State private var scanned = false
    @State private var isActive = true
    @State private var lastCode = ""
    @State private var flashOn = false

    private let accent = Color(hex: "1A6BFF")

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isActive {
                BarcodeCameraView(onBarcodeFound: handleScan, isActive: $isActive)
                    .ignoresSafeArea()
            }
            overlay
        }
        .statusBarHidden(true)
    }

    private var overlay: some View {
        VStack(spacing: 0) {
            topBar
            Spacer()
            scanFrame
            Spacer()
            bottomBar
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.15))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Scan Barcode")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Button(action: { flashOn.toggle() }) {
                Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.15))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }

    private var scanFrame: some View {
        ZStack {
            // dim overlay with cutout
            Color.black.opacity(0.55)
                .mask(
                    Rectangle()
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: 270, height: 180)
                                .blendMode(.destinationOut)
                        )
                )
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 18)
                .stroke(scanned ? Color.green : Color.white, lineWidth: 3)
                .frame(width: 270, height: 180)
                .overlay(cornerBrackets)
                .animation(.easeInOut(duration: 0.3), value: scanned)

            VStack(spacing: 10) {
                Image(systemName: scanned ? "checkmark.circle.fill" : "barcode.viewfinder")
                    .font(.system(size: 32))
                    .foregroundColor(scanned ? .green : .white.opacity(0.7))
                Text(scanned ? "Barcode detected!" : "Align barcode within frame")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }

    private var cornerBrackets: some View {
        ZStack {
            BracketCorner().frame(width: 270, height: 180)
            BracketCorner().frame(width: 270, height: 180).scaleEffect(x: -1, y: 1)
            BracketCorner().frame(width: 270, height: 180).scaleEffect(x: 1, y: -1)
            BracketCorner().frame(width: 270, height: 180).scaleEffect(x: -1, y: -1)
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 16) {
            if scanned {
                Text("Code: \(lastCode)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Button(action: {
                if scanned {
                    dismiss()
                    onBarcodeFound(lastCode)
                }
            }) {
                Text(scanned ? "Use This Barcode" : "Scanning…")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(scanned ? .white : .white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(scanned ? accent : Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!scanned)
            .padding(.horizontal, 32)

            Button(action: { dismiss() }) {
                Text("Cancel")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.bottom, 50)
    }

    private func handleScan(_ code: String) {
        guard !scanned else { return }
        lastCode = code
        scanned = true
        isActive = false
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

private struct BracketCorner: View {
    var body: some View {
        Canvas { context, size in
            let len: CGFloat = 24
            let t: CGFloat = 3.5
            var path = Path()
            path.move(to: CGPoint(x: 0 + len, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: len))
            context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: t, lineCap: .round))
        }
    }
}
