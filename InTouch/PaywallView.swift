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
            ScrollView {
                VStack(spacing: 32) {
                    header
                        .claudeColumnLayout()

                    features
                        .claudeColumnLayout()

                    pricing
                        .claudeColumnLayout()

                    purchaseButton
                        .claudeColumnLayout()

                    footer
                        .claudeColumnLayout()

                    Spacer(minLength: 40)
                }
                .padding(.vertical, 20)
            }
            .background(ClaudeBackground().ignoresSafeArea())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(ClaudeColors.mediumGray)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 20) {
            Image(systemName: "crown.fill")
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ClaudeColors.claudeOrange, ClaudeColors.claudeOrangeDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Unlock Premium")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(ClaudeColors.charcoal)

            Text("Stay connected with unlimited spins and powerful features")
                .font(ClaudeTypography.bodyFont)
                .foregroundStyle(ClaudeColors.mediumGray)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Features

    private var features: some View {
        VStack(spacing: 16) {
            featureRow(
                icon: "infinity.circle.fill",
                title: "Unlimited Spins",
                description: "Spin as many times as you want, every day"
            )

            featureRow(
                icon: "bell.badge.fill",
                title: "Multiple Reminders",
                description: "Set multiple daily notifications (coming soon)"
            )

            featureRow(
                icon: "person.3.fill",
                title: "Custom Lists",
                description: "Create custom contact groups (coming soon)"
            )

            featureRow(
                icon: "chart.line.uptrend.xyaxis.circle.fill",
                title: "Advanced Analytics",
                description: "Deep insights into your connection patterns"
            )
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(ClaudeColors.claudeOrange)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(ClaudeTypography.calloutFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(ClaudeColors.charcoal)

                Text(description)
                    .font(ClaudeTypography.subheadlineFont)
                    .foregroundStyle(ClaudeColors.mediumGray)
            }

            Spacer()
        }
        .padding(20)
        .background(ClaudeColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ClaudeColors.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Pricing

    private var pricing: some View {
        VStack(spacing: 12) {
            if let monthly = subscriptionManager.getMonthlyProduct() {
                pricingCard(
                    product: monthly,
                    title: "Monthly",
                    description: "Billed monthly",
                    isPopular: false
                )
            }

            if let yearly = subscriptionManager.getYearlyProduct() {
                pricingCard(
                    product: yearly,
                    title: "Yearly",
                    description: "Best value - save 30%",
                    isPopular: true
                )
            }

            if subscriptionManager.availableProducts.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(ClaudeColors.claudeOrange)
                    Text("Loading premium options...")
                        .font(ClaudeTypography.calloutFont)
                        .foregroundStyle(ClaudeColors.mediumGray)
                }
                .padding(32)
            }
        }
    }

    private func pricingCard(product: Product, title: String, description: String, isPopular: Bool) -> some View {
        Button {
            selectedProduct = product
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(ClaudeTypography.title3Font)
                            .foregroundStyle(ClaudeColors.charcoal)

                        if isPopular {
                            ClaudeBadge("Popular", color: ClaudeColors.claudeOrange)
                        }
                    }

                    Text(description)
                        .font(ClaudeTypography.subheadlineFont)
                        .foregroundStyle(ClaudeColors.mediumGray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(product.displayPrice)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(ClaudeColors.charcoal)

                    if let savings = subscriptionManager.getYearlySavings(), title == "Yearly" {
                        Text(savings)
                            .font(ClaudeTypography.captionFont)
                            .fontWeight(.semibold)
                            .foregroundStyle(ClaudeColors.softGreen)
                    }
                }

                Image(systemName: selectedProduct == product ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(selectedProduct == product ? ClaudeColors.claudeOrange : ClaudeColors.lightGray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selectedProduct == product ?
                        ClaudeColors.claudeOrange.opacity(0.08) :
                        ClaudeColors.warmWhite
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        selectedProduct == product ?
                            ClaudeColors.claudeOrange :
                            ClaudeColors.border,
                        lineWidth: selectedProduct == product ? 2 : 1
                    )
            )
        }
    }

    // MARK: - Purchase Button

    private var purchaseButton: some View {
        VStack(spacing: 16) {
            Button {
                purchaseSelected()
            } label: {
                HStack {
                    if isPurchasing {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "crown.fill")
                        Text("Start Premium")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .claudePrimaryButton()
            .disabled(selectedProduct == nil || isPurchasing)
            .opacity((selectedProduct == nil || isPurchasing) ? 0.6 : 1.0)

            Button {
                restorePurchases()
            } label: {
                Text("Restore Purchases")
                    .font(ClaudeTypography.calloutFont)
                    .foregroundStyle(ClaudeColors.claudeOrange)
            }
            .disabled(isPurchasing)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 12) {
            Text("Subscriptions auto-renew unless cancelled 24 hours before the end of the current period.")
                .font(ClaudeTypography.footnoteFont)
                .foregroundStyle(ClaudeColors.mediumGray)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Link("Terms", destination: URL(string: "https://intouch.app/terms")!)
                    .font(ClaudeTypography.footnoteFont)
                    .foregroundStyle(ClaudeColors.claudeOrange)

                Text("•")
                    .foregroundStyle(ClaudeColors.lightGray)

                Link("Privacy", destination: URL(string: "https://intouch.app/privacy")!)
                    .font(ClaudeTypography.footnoteFont)
                    .foregroundStyle(ClaudeColors.claudeOrange)
            }
        }
    }

    // MARK: - Actions

    private func purchaseSelected() {
        guard let product = selectedProduct else { return }

        Task {
            isPurchasing = true
            defer { isPurchasing = false }

            do {
                let transaction = try await subscriptionManager.purchase(product)
                if transaction != nil {
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func restorePurchases() {
        Task {
            isPurchasing = true
            defer { isPurchasing = false }

            await subscriptionManager.restorePurchases()

            if subscriptionManager.isSubscribed {
                dismiss()
            } else {
                errorMessage = "No previous purchases found"
                showError = true
            }
        }
    }
}
