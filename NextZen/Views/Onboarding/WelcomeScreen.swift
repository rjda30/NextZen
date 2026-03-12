import SwiftUI

struct WelcomeScreen: View {
    let onGetStarted: () -> Void

    private let accent = Color(hex: "1A6BFF")

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            heroIllustration
            Spacer(minLength: 0)
            textContent
                .padding(.horizontal, 28)
            Spacer(minLength: 24)
            bottomActions
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
        }
        .background(Color.white.ignoresSafeArea())
    }

    // MARK: Illustration
    private var heroIllustration: some View {
        ZStack {
            // Background blob
            Ellipse()
                .fill(accent.opacity(0.07))
                .frame(width: 340, height: 280)
                .offset(y: -10)

            // Floating room cards
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    roomPill(icon: "sofa.fill", label: "Living Room", color: accent)
                    roomPill(icon: "refrigerator.fill", label: "Kitchen", color: Color(hex: "FF6B2B"))
                }
                HStack(spacing: 14) {
                    roomPill(icon: "bed.double.fill", label: "Bedroom", color: Color(hex: "AF52DE"))
                    roomPill(icon: "car.fill", label: "Garage", color: Color(hex: "34C759"))
                }
            }

            // Center logo circle
            ZStack {
                Circle()
                    .fill(accent)
                    .frame(width: 70, height: 70)
                    .shadow(color: accent.opacity(0.4), radius: 16, y: 6)
                Image(systemName: "house.lodge.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(height: 320)
    }

    private func roomPill(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.07), radius: 10, y: 4)
    }

    // MARK: Text
    private var textContent: some View {
        VStack(spacing: 12) {
            Text("Your home,\nfinally organized.")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            Text("Track every item, store documents,\nand never miss maintenance again.")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: Actions
    private var bottomActions: some View {
        VStack(spacing: 14) {
            Button(action: onGetStarted) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(accent)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button("Sign In") {}
                    .fontWeight(.semibold)
                    .foregroundColor(accent)
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
