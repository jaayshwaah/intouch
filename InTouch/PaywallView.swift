import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 32) {
                        header
                        
                        features
                        
                        pricing
                        
                        benefits
                        
                        buttons
                        
                        footer
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .task {
            await subscriptionManager.loadProducts()
        }
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(colors: [
                        Color.yellow,
                        Color.orange
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
            
            Text("Unlock Premium")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            Text("Get unlimited spins and premium features")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Features
    
    private var features: some View {
        VStack(spacing: 16) {
            FeatureRow(icon: "infinity", title: "Unlimited Spins", description: "Spin as much as you want")
            FeatureRow(icon: "person.2.fill", title: "Advanced Filtering", description: "Filter by relationship, last contact")
            FeatureRow(icon: "chart.bar.fill", title: "Contact Analytics", description: "See your connection patterns")
            FeatureRow(icon: "bell.fill", title: "Smart Reminders", description: "Never lose touch again")
            FeatureRow(icon: "paintbrush.fill", title: "Custom Themes", description: "Personalize your experience")
        }
    }
    
    // MARK: - Pricing
    
    private var pricing: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
            
            if let monthly = subscriptionManager.getMonthlyProduct(),
               let yearly = subscriptionManager.getYearlyProduct() {
                
                VStack(spacing: 12) {
                    // Yearly Plan (Recommended)
                    PricingCard(
                        product: yearly,
                        isRecommended: true,
                        isSelected: selectedProduct?.id == yearly.id
                    ) {
                        selectedProduct = yearly
                    }
                    
                    // Monthly Plan
                    PricingCard(
                        product: monthly,
                        isRecommended: false,
                        isSelected: selectedProduct?.id == monthly.id
                    ) {
                        selectedProduct = monthly
                    }
                }
                
                if let savings = subscriptionManager.getYearlySavings() {
                    Text(savings)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.green.opacity(0.2), in: Capsule())
                }
            } else {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)
            }
        }
    }
    
    // MARK: - Benefits
    
    private var benefits: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Cancel anytime")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("7-day free trial")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Family sharing included")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Buttons
    
    private var buttons: some View {
        VStack(spacing: 12) {
            Button {
                Task {
                    await purchaseSelected()
                }
            } label: {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "crown.fill")
                    }
                    Text(isPurchasing ? "Processing..." : "Start Free Trial")
                        .font(.headline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(colors: [
                        Color.blue,
                        Color.purple
                    ], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
            }
            .disabled(selectedProduct == nil || isPurchasing)
            
            Button {
                Task {
                    await subscriptionManager.restorePurchases()
                    if subscriptionManager.isSubscribed {
                        dismiss()
                    }
                }
            } label: {
                Text("Restore Purchases")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
    
    // MARK: - Footer
    
    private var footer: some View {
        VStack(spacing: 8) {
            Text("Terms of Service • Privacy Policy")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Actions
    
    private func purchaseSelected() async {
        guard let product = selectedProduct else { return }
        
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let _ = try await subscriptionManager.purchase(product)
            if subscriptionManager.isSubscribed {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(colors: [
                        Color.blue,
                        Color.purple
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
}

struct PricingCard: View {
    let product: Product
    let isRecommended: Bool
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                        
                        if isRecommended {
                            Text("BEST VALUE")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.yellow, in: Capsule())
                        }
                    }
                    
                    Text(priceText)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .white.opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.blue : Color.white.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var priceText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceFormatStyle.locale
        return formatter.string(from: product.price) ?? product.displayPrice
    }
}

#Preview {
    PaywallView()
}
