import SwiftUI

struct HomeTypeScreen: View {
    let onFinish: () -> Void
    let onBack: () -> Void
    @State private var selected: String?

    private let options = [
        ("Apartment", "building.2.fill"),
        ("House", "house.fill"),
        ("Condo", "building.fill"),
        ("Studio", "door.left.hand.open"),
        ("Other", "ellipsis.circle.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            Spacer().frame(height: 24)
            titleSection
            Spacer().frame(height: 32)
            optionsList
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
            fullProgress
            Spacer()
            Color.clear.frame(width: 24)
        }
        .padding(.top, 16)
    }

    private var fullProgress: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { _ in
                Capsule().fill(Color.black).frame(width: 8, height: 4)
            }
            Capsule().fill(Color.black).frame(width: 28, height: 4)
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What type of home\ndo you live in?")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            Text("This helps us customize your experience.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var optionsList: some View {
        VStack(spacing: 12) {
            ForEach(options, id: \.0) { option in
                optionRow(label: option.0, icon: option.1)
            }
        }
    }

    private func optionRow(label: String, icon: String) -> some View {
        let isSelected = selected == label
        return Button { selected = label } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(width: 40, height: 40)
                    .background(isSelected ? Color.black : Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(label)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.black : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var continueButton: some View {
        Button(action: onFinish) {
            Text("Continue")
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(selected != nil ? Color(white: 0.12) : Color(.systemGray4))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .disabled(selected == nil)
    }
}
