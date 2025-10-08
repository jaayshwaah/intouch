import Foundation
import StoreKit
import Observation

@Observable
@MainActor
final class SubscriptionManager {
    static let shared = SubscriptionManager()
    
    // Product IDs - IMPORTANT: Update these to match your App Store Connect configuration
    // Format: com.yourcompany.intouch.premium.monthly and com.yourcompany.intouch.premium.yearly
    // See SETUP.md for instructions on configuring in-app purchases
    private let monthlyProductID = "com.joshking.InTouch.premium.monthly"
    private let yearlyProductID = "com.joshking.InTouch.premium.yearly"
    
    // Subscription state
    var isSubscribed = false
    var subscriptionStatus: SubscriptionStatus = .unknown
    var availableProducts: [Product] = []
    var purchasedProducts: [Product] = []
    
    // Usage tracking
    private let dailySpinsKey = "dailySpinsCount"
    private let lastResetDateKey = "lastResetDate"
    private let maxFreeSpins = 3
    
    enum SubscriptionStatus {
        case unknown
        case subscribed
        case notSubscribed
        case expired
    }
    
    private init() {
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    // MARK: - StoreKit Integration
    
    func loadProducts() async {
        do {
            let productIDs = [monthlyProductID, yearlyProductID]
            let products = try await Product.products(for: productIDs)
            availableProducts = products.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func updateSubscriptionStatus() async {
        var isCurrentlySubscribed = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == monthlyProductID || transaction.productID == yearlyProductID {
                    isCurrentlySubscribed = true
                    break
                }
            }
        }
        
        isSubscribed = isCurrentlySubscribed
        subscriptionStatus = isCurrentlySubscribed ? .subscribed : .notSubscribed
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            if case .verified(let transaction) = verification {
                await transaction.finish()
                await updateSubscriptionStatus()
                return transaction
            }
            return nil
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await updateSubscriptionStatus()
    }
    
    // MARK: - Usage Tracking
    
    func canSpin() -> Bool {
        if isSubscribed {
            return true
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastReset = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date ?? Date.distantPast
        let lastResetDay = Calendar.current.startOfDay(for: lastReset)
        
        // Reset daily count if it's a new day
        if today > lastResetDay {
            UserDefaults.standard.set(0, forKey: dailySpinsKey)
            UserDefaults.standard.set(today, forKey: lastResetDateKey)
        }
        
        let currentSpins = UserDefaults.standard.integer(forKey: dailySpinsKey)
        return currentSpins < maxFreeSpins
    }
    
    func recordSpin() {
        guard !isSubscribed else { return }
        
        let currentSpins = UserDefaults.standard.integer(forKey: dailySpinsKey)
        UserDefaults.standard.set(currentSpins + 1, forKey: dailySpinsKey)
    }
    
    func remainingFreeSpins() -> Int {
        guard !isSubscribed else { return -1 } // Unlimited
        
        let currentSpins = UserDefaults.standard.integer(forKey: dailySpinsKey)
        return max(0, maxFreeSpins - currentSpins)
    }
    
    func resetDailySpins() {
        UserDefaults.standard.set(0, forKey: dailySpinsKey)
        UserDefaults.standard.set(Date(), forKey: lastResetDateKey)
    }
    
    // MARK: - Helper Methods
    
    func getMonthlyProduct() -> Product? {
        return availableProducts.first { $0.id == monthlyProductID }
    }
    
    func getYearlyProduct() -> Product? {
        return availableProducts.first { $0.id == yearlyProductID }
    }
    
    func getYearlySavings() -> String? {
        guard let monthly = getMonthlyProduct(),
              let yearly = getYearlyProduct() else { return nil }

        // Compute the cost of paying monthly for a year
        let monthlyYearly = monthly.price * Decimal(12)
        // Avoid division by zero or negative/zero pricing edge cases
        guard monthlyYearly > 0 else { return nil }

        // Savings is how much cheaper the yearly plan is compared to 12 months of monthly
        let savings = monthlyYearly - yearly.price
        // If there's no savings (or yearly is more expensive), don't show a savings label
        guard savings > 0 else { return nil }

        // Calculate percentage savings as an integer
        let ratio = (savings / monthlyYearly) * Decimal(100)
        let percentage = NSDecimalNumber(decimal: ratio).intValue

        return "Save \(percentage)%"
    }
}
