import SwiftUI

struct OnboardingFeatureView: View {
    let step: Int
    let onContinue: () -> Void
    let onBack: () -> Void

    private let accent = Color(hex: "1A6BFF")
    private let orange = Color(hex: "FF6B2B")

    private struct FeatureData {
        let icon: String
        let iconBg: Color
        let title: String
        let subtitle: String
        let bullets: [(String, String, Color)]
    }

    private let features: [FeatureData] = [
        FeatureData(
            icon: "cube.box.fill",
            iconBg: Color(hex: "1A6BFF"),
            title: "Track Everything\nIn Your Home",
            subtitle: "Every item, every room — organized and searchable.",
            bullets: [
                ("square.grid.2x2.fill", "Organize by room", Color(hex: "1A6BFF")),
                ("barcode.viewfinder", "Scan to add items instantly", Color(hex: "FF6B2B")),
                ("magnifyingglass", "Search your entire home", Color(hex: "34C759"))
            ]
        ),
        FeatureData(
            icon: "bell.badge.fill",
            iconBg: Color(hex: "FF6B2B"),
            title: "Never Miss\nMaintenance Again",
            subtitle: "Smart reminders keep your home running perfectly.",
            bullets: [
                ("checkmark.shield.fill", "Warranty expiry alerts", Color(hex: "1A6BFF")),
                ("doc.fill", "Store receipts & manuals", Color(hex: "FF6B2B")),
                ("sparkles", "AI-powered maintenance tips", Color(hex: "34C759"))
            ]
        )
    ]

    private var data: FeatureData { features[min(step, features.count - 1)] }

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Spacer(minLength: 0)
            illustration
            VStack(alignment: .leading, spacing: 24) {
                titleBlock
                bulletList
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
            bottomBar
        }
        .background(Color.white.ignoresSafeArea())
    }

    // MARK: Top Bar
    private var topBar: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 38, height: 38)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            Spacer()
            HStack(spacing: 6) {
                ForEach(0..<2, id: \.self) { i in
                    Capsule()
                        .fill(i == step ? accent : Color(.systemGray4))
                        .frame(width: i == step ? 24 : 8, height: 4)
                }
            }
            Spacer()
            Color.clear.frame(width: 38)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: Illustration
    private var illustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(data.iconBg.opacity(0.08))
                .frame(height: 220)
                .padding(.horizontal, 24)
            ZStack {
                Circle()
                    .fill(data.iconBg.opacity(0.15))
                    .frame(width: 120, height: 120)
                Circle()
                    .fill(data.iconBg.opacity(0.25))
                    .frame(width: 88, height: 88)
                Image(systemName: data.icon)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(data.iconBg)
            }
        }
        .padding(.vertical, 20)
    }

    // MARK: Title
    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text(data.subtitle)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }

    // MARK: Bullets
    private var bulletList: some View {
        VStack(spacing: 14) {
            ForEach(data.bullets, id: \.0) { bullet in
                HStack(spacing: 14) {
                    Image(systemName: bullet.0)
                        .font(.system(size: 16))
                        .foregroundColor(bullet.2)
                        .frame(width: 36, height: 36)
                        .background(bullet.2.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(bullet.1)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
        }
    }

    // MARK: Bottom
    private var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: onContinue) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
    }
}
