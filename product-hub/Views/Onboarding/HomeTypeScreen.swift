import SwiftUI

struct HomeTypeScreen: View {
    let onFinish: () -> Void
    let onBack: () -> Void

    @State private var selectedType: String? = nil
    @State private var homeName: String = ""
    @FocusState private var nameFieldFocused: Bool

    private let homeTypes: [(icon: String, label: String, color: Color)] = [
        ("building.2.fill", "Apartment", Color(hex: "3B82F6")),
        ("house.fill", "House", Color(hex: "34D399")),
        ("building.fill", "Condo", Color(hex: "8B5CF6")),
        ("studentdesk", "Studio", Color(hex: "F59E0B")),
        ("tent.fill", "Townhouse", Color(hex: "EC4899")),
        ("questionmark.square.fill", "Other", Color(hex: "6B7280"))
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "0A0A2E"), Color(hex: "0d2137")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                headerBar
                    .padding(.top, 56)
                    .padding(.horizontal, 24)
                Spacer().frame(height: 28)
                titleSection
                    .padding(.horizontal, 24)
                Spacer().frame(height: 28)
                nameField
                    .padding(.horizontal, 24)
                Spacer().frame(height: 24)
                typeGrid
                    .padding(.horizontal, 24)
                Spacer()
                finishButton
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
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule()
                        .fill(i < 3 ? Color(hex: "6C63FF") : (selectedType != nil ? Color(hex: "6C63FF") : Color.white.opacity(0.25)))
                        .frame(width: i == 3 ? 28 : 8, height: 4)
                }
            }
            Spacer()
            Color.clear.frame(width: 36)
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Set up your home")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text("Name your home and choose the type of space you're organizing.")
                .font(.body)
                .foregroundColor(.white.opacity(0.65))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Home Name").font(.caption).foregroundColor(.white.opacity(0.6)).textCase(.uppercase)
            HStack {
                Image(systemName: "house.fill").foregroundColor(Color(hex: "6C63FF"))
                TextField("e.g. My Apartment", text: $homeName)
                    .foregroundColor(.white)
                    .focused($nameFieldFocused)
            }
            .padding(14)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "6C63FF").opacity(nameFieldFocused ? 0.7 : 0.2), lineWidth: 1))
        }
    }

    private var typeGrid: some View {
        let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: cols, spacing: 12) {
            ForEach(homeTypes, id: \.label) { type in
                typeCard(type: type)
            }
        }
    }

    private func typeCard(type: (icon: String, label: String, color: Color)) -> some View {
        let isSelected = selectedType == type.label
        return Button(action: { selectedType = type.label }) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelected ? type.color : Color.white.opacity(0.08))
                        .frame(width: 54, height: 54)
                    Image(systemName: type.icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .white : type.color)
                }
                Text(type.label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isSelected ? type.color.opacity(0.18) : Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? type.color : Color.clear, lineWidth: 1.5))
        }
    }

    private var canFinish: Bool { selectedType != nil }

    private var finishButton: some View {
        Button(action: onFinish) {
            Text("Let's Go!")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(canFinish
                    ? LinearGradient(colors: [Color(hex: "6C63FF"), Color(hex: "3B82F6")], startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.15)], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(canFinish ? .white : .white.opacity(0.4))
                .clipShape(Capsule())
        }
        .disabled(!canFinish)
    }
}
