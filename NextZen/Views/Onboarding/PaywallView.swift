import SwiftUI
import RevenueCat

struct PaywallView: View {
    let onContinue: () -> Void
    let onBack: () -> Void

    @StateObject private var purchases = PurchaseService.shared
    @State private var selectedPlan: Plan = .yearly

    private let accent = Color(hex: "1A6BFF")
    private let orange = Color(hex: "FF6B2B")

    enum Plan { case monthly, yearly }

    private let features = [
        ("cube.box.fill",       "Unlimited items & rooms",      Color(hex: "1A6BFF")),
        ("bell.badge.fill",     "Smart maintenance alerts",     Color(hex: "FF6B2B")),
        ("doc.fill",            "Document & receipt storage",   Color(hex: "34C759")),
        ("checkmark.shield.fill","Warranty tracking",           Color(hex: "AF52DE")),
        ("barcode.viewfinder",  "Barcode scanning",             Color(hex: "1A6BFF")),
        ("sparkles",            "AI-powered suggestions",       Color(hex: "FF6B2B"))
    ]

    var body: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    headerSection
                    featureList
                    planSelector
                    ctaSection
                    restoreButton
                    legalText
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .task { await purchases.loadOfferings() }
        .overlay {
            if purchases.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView().tint(.white).scaleEffect(1.4)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { purchases.errorMessage != nil },
            set: { if !$0 { purchases.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(purchases.errorMessage ?? "")
        }
    }

    // MARK: Top
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
            Text("Premium")
                .font(.system(size: 16, weight: .semibold))
            Spacer()
            Color.clear.frame(width: 38)
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .padding(.bottom, 12)
    }

    // MARK: Header
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(accent.opacity(0.12)).frame(width: 80, height: 80)
                Image(systemName: "crown.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(
                        LinearGradient(colors: [orange, accent],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            Text("Unlock NextZen Premium")
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
            Text("Everything you need to manage\nyour home like a pro.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: Features
    private var featureList: some View {
        VStack(spacing: 10) {
            ForEach(features, id: \.0) { feature in
                HStack(spacing: 14) {
                    Image(systemName: feature.0)
                        .font(.system(size: 15))
                        .foregroundColor(feature.2)
                        .frame(width: 34, height: 34)
                        .background(feature.2.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                    Text(feature.1)
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(18)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: Plans
    private var planSelector: some View {
        VStack(spacing: 10) {
            planCard(plan: .yearly,  title: "Yearly",  price: yearlyPrice,   badge: "Best Value", sub: "Just \(yearlyMonthly)/month")
            planCard(plan: .monthly, title: "Monthly", price: monthlyPrice,  badge: nil,          sub: "Cancel anytime")
        }
    }

    private var yearlyPrice: String {
        if let pkg = purchases.offerings?.current?.annual {
            return pkg.storeProduct.localizedPriceString + "/yr"
        }
        return "$29.99/yr"
    }

    private var monthlyPrice: String {
        if let pkg = purchases.offerings?.current?.monthly {
            return pkg.storeProduct.localizedPriceString + "/mo"
        }
        return "$4.99/mo"
    }

    private var yearlyMonthly: String {
        if let pkg = purchases.offerings?.current?.annual {
            let monthly = pkg.storeProduct.price / 12
            let formatted = pkg.storeProduct.priceFormatter?.string(from: monthly as NSDecimalNumber) ?? "$2.50"
            return formatted
        }
        return "$2.50"
    }

    private func planCard(plan: Plan, title: String, price: String, badge: String?, sub: String) -> some View {
        let isSelected = selectedPlan == plan
        return Button(action: { selectedPlan = plan }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? accent : Color(.systemGray4), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(accent).frame(width: 12, height: 12)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        if let badge = badge {
                            Text(badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(orange)
                                .clipShape(Capsule())
                        }
                    }
                    Text(sub)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(price)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? accent : .primary)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? accent : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // MARK: CTA
    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                Task {
                    if selectedPlan == .yearly {
                        await purchases.purchaseYearly()
                    } else {
                        await purchases.purchaseMonthly()
                    }
                    if purchases.isPremium { onContinue() }
                }
            }) {
                Text(selectedPlan == .yearly ? "Start Free 7-Day Trial" : "Get Monthly Access")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: [accent, Color(hex: "0049CC")],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(purchases.isLoading)

            Button(action: onContinue) {
                Text("Maybe later")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .underline()
            }
        }
    }

    private var restoreButton: some View {
        Button(action: {
            Task {
                await purchases.restorePurchases()
                if purchases.isPremium { onContinue() }
            }
        }) {
            Text("Restore Purchases")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }

    private var legalText: some View {
        Text("Payment will be charged to your Apple ID at confirmation. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.")
            .font(.system(size: 11))
            .foregroundColor(Color(.tertiaryLabel))
            .multilineTextAlignment(.center)
    }
}
