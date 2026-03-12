import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1A6BFF"), Color(hex: "0049CC")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 320, height: 320)
                .offset(x: 130, y: -220)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 220, height: 220)
                .offset(x: -120, y: 260)

            VStack(spacing: 20) {
                Spacer()

                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 96, height: 96)
                    Image(systemName: "house.lodge.fill")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // App name
                Text("NextZen")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textOpacity)

                Text("Smart Home Management")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
                    .opacity(taglineOpacity)

                Spacer()
                Spacer()
            }
        }
        .onAppear { animateIn() }
    }

    private func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            textOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
            taglineOpacity = 1.0
        }
    }
}
