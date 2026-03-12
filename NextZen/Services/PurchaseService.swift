import Foundation
import RevenueCat
import SwiftUI

// MARK: - Product IDs (update these in RevenueCat dashboard)
enum NZProduct: String {
    case monthly  = "nextzen_premium_monthly"
    case yearly   = "nextzen_premium_yearly"
}

// MARK: - PurchaseService
@MainActor
final class PurchaseService: ObservableObject {
    static let shared = PurchaseService()

    @Published var isPremium = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var offerings: Offerings? = nil

    private init() {}

    // Call once at app launch after setting up RevenueCat API key
    func configure(apiKey: String) {
        Purchases.configure(withAPIKey: apiKey)
        Purchases.shared.delegate = nil
        Task { await refreshStatus() }
    }

    func refreshStatus() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            isPremium = info.entitlements["premium"]?.isActive == true
        } catch {
            NSLog("[PurchaseService] refreshStatus error: \(error.localizedDescription)")
        }
    }

    func loadOfferings() async {
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            NSLog("[PurchaseService] loadOfferings error: \(error.localizedDescription)")
        }
    }

    func purchaseMonthly() async {
        await purchase(productId: NZProduct.monthly.rawValue)
    }

    func purchaseYearly() async {
        await purchase(productId: NZProduct.yearly.rawValue)
    }

    private func purchase(productId: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let products = try await Purchases.shared.products([productId])
            guard let product = products.first else {
                errorMessage = "Product not found. Please try again."
                isLoading = false
                return
            }
            let (_, info, userCancelled) = try await Purchases.shared.purchase(product: product)
            if !userCancelled {
                isPremium = info.entitlements["premium"]?.isActive == true
            }
        } catch {
            errorMessage = error.localizedDescription
            NSLog("[PurchaseService] purchase error: \(error.localizedDescription)")
        }
        isLoading = false
    }

    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        do {
            let info = try await Purchases.shared.restorePurchases()
            isPremium = info.entitlements["premium"]?.isActive == true
            if !isPremium {
                errorMessage = "No active subscription found."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
