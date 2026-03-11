import SwiftUI

struct WelcomeScreen: View {
    let onGetStarted: () -> Void

    var body: some View {
        ZStack {
            gradientBG
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                logoSection
                Spacer()
                phonePreview
                Spacer()
                titleSection
                Spacer().frame(height: 32)
                bottomActions
                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 28)
        }
        .ignoresSafeArea()
    }

    private var gradientBG: some View {
        LinearGradient(
            colors: [Color(hex: "0A0A2E"), Color(hex: "1a1a4e"), Color(hex: "0d2137")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var logoSection: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Image(systemName: "house.lodge.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            Text("NextZen")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private var phonePreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.white.opacity(0.08))
                .frame(height: 260)
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    ForEach(previewRooms, id: \.0) { room in
                        roomChip(icon: room.0, label: room.1, color: room.2)
                    }
                }
                HStack(spacing: 8) {
                    miniStat(label: "67 Items", icon: "cube.fill")
                    miniStat(label: "6 Rooms", icon: "square.grid.2x2")
                    miniStat(label: "2 Alerts", icon: "bell.fill")
                }
            }
        }
    }

    private let previewRooms: [(String, String, Color)] = [
        ("sofa.fill", "Living", Color(hex: "3B82F6")),
        ("refrigerator.fill", "Kitchen", Color(hex: "F59E0B")),
        ("bed.double.fill", "Bedroom", Color(hex: "8B5CF6"))
    ]

    private func roomChip(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            Text(label).font(.caption).foregroundColor(.white.opacity(0.8))
        }
    }

    private func miniStat(label: String, icon: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.caption2).foregroundColor(.white.opacity(0.6))
            Text(label).font(.caption2).foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color.white.opacity(0.1))
        .clipShape(Capsule())
    }

    private var titleSection: some View {
        VStack(spacing: 10) {
            Text("Your home,\nfinally organized")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Text("Track every item, store every document,\nnever miss maintenance again.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.6))
        }
    }

    private var bottomActions: some View {
        VStack(spacing: 14) {
            Button(action: onGetStarted) {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")],
                                               startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            HStack(spacing: 4) {
                Text("Already have an account?").foregroundColor(.white.opacity(0.5))
                Button("Sign In") {}.fontWeight(.semibold).foregroundColor(.white)
            }
            .font(.subheadline)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
