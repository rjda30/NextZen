import SwiftUI

struct OnboardingStepView: View {
    let step: Int
    let onContinue: () -> Void
    let onBack: () -> Void

    private struct StepData {
        let title: String
        let subtitle: String
        let gradientColors: [Color]
        let items: [(icon: String, label: String, desc: String)]
    }

    private let steps: [StepData] = [
        StepData(
            title: "Every room, perfectly organized",
            subtitle: "Track appliances, furniture, and everything inside your home.",
            gradientColors: [Color(hex: "0A0A2E"), Color(hex: "1a2a5e")],
            items: [
                ("sofa.fill", "Living Room", "12 items tracked"),
                ("refrigerator.fill", "Kitchen", "18 items tracked"),
                ("bed.double.fill", "Bedroom", "8 items tracked"),
                ("car.fill", "Garage", "15 items tracked")
            ]
        ),
        StepData(
            title: "Never lose a manual again",
            subtitle: "Store receipts, warranties, and docs — all searchable by AI.",
            gradientColors: [Color(hex: "0d1f3c"), Color(hex: "1a3a2a")],
            items: [
                ("book.fill", "Product Manuals", "Always at hand"),
                ("receipt.fill", "Receipts", "For every purchase"),
                ("checkmark.shield.fill", "Warranties", "Track expirations"),
                ("folder.fill", "Documents", "Everything organized")
            ]
        ),
        StepData(
            title: "Smart reminders save your home",
            subtitle: "Get alerts for maintenance, warranty expirations, and recalls.",
            gradientColors: [Color(hex: "1f0a2e"), Color(hex: "2a1a0d")],
            items: [
                ("wind", "HVAC Filter", "Due in 1 day"),
                ("flame.fill", "Smoke Detector", "Battery low"),
                ("exclamationmark.shield.fill", "Warranty Alert", "Expires soon"),
                ("sparkles", "Deep Clean", "Scheduled")
            ]
        )
    ]

    private var data: StepData { steps[min(step, steps.count - 1)] }

    private let accentColors: [Color] = [Color(hex: "6C63FF"), Color(hex: "34D399"), Color(hex: "F59E0B")]

    var body: some View {
        ZStack {
            LinearGradient(colors: data.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                headerBar
                    .padding(.top, 56)
                    .padding(.horizontal, 24)
                Spacer().frame(height: 28)
                titleSection
                    .padding(.horizontal, 24)
                Spacer().frame(height: 32)
                featureCards
                    .padding(.horizontal, 24)
                Spacer()
                continueButton
                    .padding(.horizontal, 24)
                Spacer().frame(height: 44)
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
            }
            Spacer()
            progressDots
            Spacer()
            Color.clear.frame(width: 36)
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? accentColors[step] : Color.white.opacity(0.25))
                    .frame(width: i == step ? 28 : 8, height: 4)
                    .animation(.spring(), value: step)
            }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(data.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text(data.subtitle)
                .font(.body)
                .foregroundColor(.white.opacity(0.65))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var featureCards: some View {
        VStack(spacing: 10) {
            ForEach(Array(data.items.enumerated()), id: \.offset) { idx, item in
                featureRow(item: item, isFirst: idx == 0, accent: accentColors[step])
            }
        }
    }

    private func featureRow(item: (icon: String, label: String, desc: String), isFirst: Bool, accent: Color) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isFirst ? accent : Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(isFirst ? .white : accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(item.desc)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.55))
            }
            Spacer()
            if isFirst {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(accent)
                    .font(.body)
            }
        }
        .padding(14)
        .background(isFirst ? accent.opacity(0.18) : Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFirst ? accent.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }

    private var continueButton: some View {
        Button(action: onContinue) {
            Text("Continue")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(LinearGradient(colors: [accentColors[step], accentColors[step].opacity(0.7)],
                                           startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}
