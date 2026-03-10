import SwiftUI

struct OnboardingStepView: View {
    let step: Int
    let onContinue: () -> Void
    let onBack: () -> Void

    private let steps: [(title: String, subtitle: String, icon: String, items: [(String, String)])] = [
        (
            "Organize every room in your home",
            "Track appliances, furniture, and everything in between — all in one place.",
            "square.grid.2x2.fill",
            [("Living Room", "sofa.fill"), ("Kitchen", "refrigerator.fill"), ("Bedroom", "bed.double.fill"), ("Garage", "car.fill")]
        ),
        (
            "Never lose a manual or warranty again",
            "Store receipts, manuals, and product docs — searchable with AI.",
            "doc.text.magnifyingglass",
            [("Manuals", "book.fill"), ("Receipts", "receipt"), ("Warranties", "checkmark.shield.fill"), ("Documents", "folder.fill")]
        ),
        (
            "Smart reminders keep your home running",
            "Get alerts for maintenance, warranty expirations, and product recalls.",
            "bell.badge.fill",
            [("HVAC Filter", "wind"), ("Smoke Detector", "flame.fill"), ("Warranty", "exclamationmark.shield.fill"), ("Cleaning", "sparkles")]
        )
    ]

    private var data: (title: String, subtitle: String, icon: String, items: [(String, String)]) {
        steps[step]
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            Spacer().frame(height: 24)
            titleSection
            Spacer().frame(height: 32)
            featureCards
            Spacer()
            continueButton
            Spacer().frame(height: 40)
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }

    private var headerBar: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.title3.weight(.medium))
                    .foregroundColor(.black)
            }
            Spacer()
            progressDots
            Spacer()
            Color.clear.frame(width: 24)
        }
        .padding(.top, 16)
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? Color.black : Color(.systemGray4))
                    .frame(width: i == step ? 28 : 8, height: 4)
            }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(data.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            Text(data.subtitle)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var featureCards: some View {
        VStack(spacing: 12) {
            ForEach(Array(data.items.enumerated()), id: \.offset) { idx, item in
                featureRow(label: item.0, icon: item.1, isHighlighted: idx == 0)
            }
        }
    }

    private func featureRow(label: String, icon: String, isHighlighted: Bool) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isHighlighted ? .white : .black)
                .frame(width: 40, height: 40)
                .background(isHighlighted ? Color.black : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(label)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(isHighlighted ? .white : .primary)
            Spacer()
        }
        .padding(16)
        .background(isHighlighted ? Color.black : Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var continueButton: some View {
        Button(action: onContinue) {
            Text("Continue")
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color(white: 0.12))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}
