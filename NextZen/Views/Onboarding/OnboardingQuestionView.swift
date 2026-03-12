import SwiftUI

struct OnboardingQuestionView: View {
    let step: Int
    let question: String
    let options: [String]
    @Binding var selected: String
    let onContinue: () -> Void
    let onBack: () -> Void

    private let totalSteps = 3
    private let accent = Color(hex: "1A6BFF")

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                topBar
                    .padding(.top, geo.safeAreaInsets.top)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        questionHeader
                        optionsList
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
                bottomBar
                    .padding(.bottom, geo.safeAreaInsets.bottom)
            }
            .background(Color.white)
        }
        .ignoresSafeArea()
    }

    // MARK: Top Bar
    private var topBar: some View {
        VStack(spacing: 10) {
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
                Text("Step \(step + 1) of \(totalSteps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Color.clear.frame(width: 38)
            }
            .padding(.horizontal, 24)

            progressBar
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 8)
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 4)
                RoundedRectangle(cornerRadius: 4)
                    .fill(accent)
                    .frame(width: geo.size.width * CGFloat(step + 1) / CGFloat(totalSteps), height: 4)
            }
        }
        .frame(height: 4)
    }

    // MARK: Question
    private var questionHeader: some View {
        Text(question)
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: Options
    private var optionsList: some View {
        VStack(spacing: 12) {
            ForEach(options, id: \.self) { option in
                optionButton(option)
            }
        }
    }

    private func optionButton(_ option: String) -> some View {
        let isSelected = selected == option
        return Button(action: { selected = option }) {
            HStack(spacing: 14) {
                Text(option)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(isSelected ? accent : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? accent : Color.clear, lineWidth: 2)
            )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
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
                    .background(selected.isEmpty ? Color(.systemGray4) : accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(selected.isEmpty)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white)
    }
}
