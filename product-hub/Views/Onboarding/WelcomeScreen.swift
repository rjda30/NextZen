import SwiftUI

struct WelcomeScreen: View {
    let onGetStarted: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            logoSection
            Spacer()
            phonePreview
            Spacer().frame(height: 32)
            titleSection
            Spacer().frame(height: 32)
            bottomActions
            Spacer().frame(height: 16)
        }
        .padding(.horizontal, 32)
        .background(Color.white)
    }

    private var logoSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "house.lodge.fill")
                .font(.system(size: 38, weight: .bold))
            Text("NextZen")
                .font(.system(size: 40, weight: .bold))
        }
        .foregroundColor(.black)
    }

    private var phonePreview: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color(.systemGray6))
            .frame(height: 280)
            .overlay(phonePreviewContent)
    }

    private var phonePreviewContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "house.fill")
                .font(.system(size: 44))
                .foregroundColor(.black)
            HStack(spacing: 16) {
                roomPreviewChip(icon: "sofa.fill", label: "Living")
                roomPreviewChip(icon: "refrigerator.fill", label: "Kitchen")
                roomPreviewChip(icon: "bed.double.fill", label: "Bedroom")
            }
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.08))
                .frame(width: 200, height: 8)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.05))
                .frame(width: 160, height: 8)
        }
    }

    private func roomPreviewChip(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: icon).font(.title3).foregroundColor(.black))
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
    }

    private var titleSection: some View {
        Text("Your home,\nfinally organized")
            .font(.system(size: 28, weight: .bold))
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
    }

    private var bottomActions: some View {
        VStack(spacing: 14) {
            Button(action: onGetStarted) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button("Sign In") {}
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .font(.subheadline)
        }
    }
}
