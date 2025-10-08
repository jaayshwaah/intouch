import SwiftUI
import MessageUI

struct RandomContactView: View {
    @State private var vm = RandomContactViewModel()
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var notificationManager = NotificationManager.shared
    @State private var showManage = false
    @State private var showResetSeenAlert = false
    @State private var showSMS = false
    @State private var showPaywall = false
    @State private var showAnalytics = false
    @State private var showSettings = false
    @State private var showNotificationPrompt = false
    @State private var hasShownFirstSpinPrompt = UserDefaults.standard.bool(forKey: "hasShownFirstSpinPrompt")
    @State private var isSpinning = false
    @State private var conversationStarter: String = ConversationStarters.random()
    @State private var showConversationStarter = false

    var body: some View {
        NavigationStack {
            ZStack {
                ClaudeBackground()

                ScrollView {
                    VStack(spacing: 28) {
                        header
                            .claudeColumnLayout()
                            .padding(.top, 20)

                        if vm.isLoading {
                            ProgressView()
                                .controlSize(.large)
                                .tint(ClaudeColors.claudeOrange)
                                .padding(.top, 60)
                        } else if let msg = vm.statusMessage {
                            errorCard(message: msg)
                                .claudeColumnLayout()
                        } else if isSpinning {
                            // Show logo loading animation
                            LogoLoadingView()
                                .claudeColumnLayout()
                                .padding(.top, 40)
                                .padding(.bottom, 40)
                        } else if let contact = vm.current {
                            contactCard(contact)
                                .claudeColumnLayout()
                                .transition(.scale.combined(with: .opacity))

                            actionButtons(for: contact)
                                .claudeColumnLayout()
                        } else {
                            emptyStateCard
                                .claudeColumnLayout()
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ClaudeIconButton(icon: "chart.bar.fill") {
                        showAnalytics = true
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    ClaudeIconButton(icon: "gearshape.fill") {
                        showSettings = true
                    }
                }
            }
        }
        .task {
            await vm.bootstrap()
            await subscriptionManager.updateSubscriptionStatus()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showAnalytics) {
            AnalyticsView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: vm)
        }
        .alert("Stay Connected Daily?", isPresented: $showNotificationPrompt) {
            Button("Enable Reminders") {
                Task {
                    let granted = await notificationManager.requestAuthorization()
                    if !granted {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            notificationManager.openSettings()
                        }
                    }
                }
            }
            Button("Not Now", role: .cancel) {}
        } message: {
            Text("Get a daily reminder at 7pm to stay in touch with your contacts")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 16) {
            // App title
            Text("InTouch")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(ClaudeColors.charcoal)

            // TESTING: Hide spin counter
            // Spin counter or upgrade prompt
            if !subscriptionManager.isSubscribed {
                let remaining = subscriptionManager.remainingFreeSpins()
                if remaining > 0 {
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(ClaudeColors.claudeOrange)

                            Text("\(remaining) spin\(remaining == 1 ? "" : "s") left")
                                .font(ClaudeTypography.calloutFont)
                                .foregroundStyle(ClaudeColors.darkGray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(ClaudeColors.claudeOrange.opacity(0.1))
                                .overlay(
                                    Capsule()
                                        .stroke(ClaudeColors.claudeOrange.opacity(0.3), lineWidth: 1)
                                )
                        )

                        if let nextRefill = subscriptionManager.nextRefillTime() {
                            Text("Next refill: \(formatRefillTime(nextRefill))")
                                .font(ClaudeTypography.captionFont)
                                .foregroundStyle(ClaudeColors.mediumGray)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("Out of spins")
                            .font(ClaudeTypography.calloutFont)
                            .foregroundStyle(ClaudeColors.darkGray)

                        if let nextRefill = subscriptionManager.nextRefillTime() {
                            Text("Refills at \(formatRefillTime(nextRefill))")
                                .font(ClaudeTypography.captionFont)
                                .foregroundStyle(ClaudeColors.mediumGray)
                        }

                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                Text("Get Unlimited")
                            }
                        }
                        .claudePrimaryButton()
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    // MARK: - Contact Card

    private func contactCard(_ contact: ContactRecord) -> some View {
        let primary = vm.primaryPhone(for: contact)

        return VStack(spacing: 24) {
            // Avatar
            ContactAvatarView(
                fullName: contact.fullName,
                imagePNG: contact.imagePNG,
                size: 120
            )
            .shadow(color: ClaudeColors.shadow, radius: 12, x: 0, y: 4)

            // Name and phone
            VStack(spacing: 12) {
                Text(contact.fullName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(ClaudeColors.charcoal)
                    .multilineTextAlignment(.center)

                if let phone = primary {
                    VStack(spacing: 8) {
                        Text(formatPhone(phone.number))
                            .font(ClaudeTypography.title3Font)
                            .foregroundStyle(ClaudeColors.mediumGray)

                        if let label = phone.label {
                            ClaudeBadge(label.capitalized, color: ClaudeColors.claudeOrange)
                        }
                    }
                }
            }

            // Additional phones
            let extraPhones = Array(contact.phones.dropFirst())
            if !extraPhones.isEmpty {
                VStack(alignment: .center, spacing: 10) {
                    ForEach(extraPhones) { phone in
                        HStack(spacing: 12) {
                            if let label = phone.label {
                                ClaudeBadge(label.capitalized, color: ClaudeColors.mediumGray)
                            }
                            Text(formatPhone(phone.number))
                                .font(ClaudeTypography.subheadlineFont)
                                .foregroundStyle(ClaudeColors.darkGray)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }

            // Conversation starter
            if showConversationStarter {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(ClaudeColors.claudeOrange)
                        Text("Conversation Starter")
                            .font(ClaudeTypography.captionFont)
                            .fontWeight(.semibold)
                            .foregroundStyle(ClaudeColors.darkGray)
                    }

                    Text("\"\(conversationStarter)\"")
                        .font(ClaudeTypography.calloutFont)
                        .foregroundStyle(ClaudeColors.charcoal)
                        .italic()
                        .fixedSize(horizontal: false, vertical: true)

                    Button {
                        withAnimation(.easeInOut) {
                            conversationStarter = ConversationStarters.random()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 12))
                            Text("Get another idea")
                                .font(ClaudeTypography.footnoteFont)
                        }
                        .foregroundStyle(ClaudeColors.claudeOrange)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(ClaudeColors.claudeOrange.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(ClaudeColors.claudeOrange.opacity(0.2), lineWidth: 1)
                        )
                )
            } else {
                Button {
                    withAnimation(.easeInOut) {
                        showConversationStarter = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 14))
                        Text("Need a conversation starter?")
                            .font(ClaudeTypography.footnoteFont)
                    }
                    .foregroundStyle(ClaudeColors.claudeOrange)
                }
            }

            // Exclude button
            Button {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                withAnimation(.easeInOut) { vm.excludeCurrent() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                    Text("Exclude from future spins")
                        .font(ClaudeTypography.footnoteFont)
                }
                .foregroundStyle(ClaudeColors.warmRed)
            }
        }
        .claudeCardHighlight(padding: 32)
    }

    // MARK: - Action Buttons

    private func actionButtons(for contact: ContactRecord) -> some View {
        let primary = vm.primaryPhone(for: contact)?.number

        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    guard let n = primary else { return }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    vm.call(number: n)
                } label: {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call")
                    }
                    .frame(maxWidth: .infinity)
                }
                .claudePrimaryButton()

                Button {
                    guard let n = primary else { return }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    if MFMessageComposeViewController.canSendText() {
                        showSMS = true
                    } else {
                        vm.textFallbackURL(number: n)
                    }
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Text")
                    }
                    .frame(maxWidth: .infinity)
                }
                .claudeSecondaryButton()
                .sheet(isPresented: $showSMS) {
                    if let n = vm.primaryPhone(for: contact)?.number {
                        MessageComposer(recipients: [n]).ignoresSafeArea()
                    }
                }
            }

            Button {
                spinWithAnimation()
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Spin Again")
                }
                .frame(maxWidth: .infinity)
            }
            .claudeGhostButton()
        }
    }

    // MARK: - Empty State

    private var emptyStateCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(ClaudeColors.claudeOrange)

            Text("Ready to reconnect?")
                .font(ClaudeTypography.title2Font)
                .foregroundStyle(ClaudeColors.charcoal)

            Text("Tap the button below to discover who you should reach out to today.")
                .font(ClaudeTypography.bodyFont)
                .foregroundStyle(ClaudeColors.mediumGray)
                .multilineTextAlignment(.center)

            Button {
                spinWithAnimation()
            } label: {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Spin the Wheel")
                }
            }
            .claudePrimaryButton()
            .padding(.top, 8)
        }
        .claudeCard(padding: 40)
    }

    // MARK: - Error Card

    private func errorCard(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(ClaudeColors.warmRed)

            Text(message)
                .font(ClaudeTypography.bodyFont)
                .foregroundStyle(ClaudeColors.charcoal)
                .multilineTextAlignment(.center)

            Button {
                vm.openAppSettings()
            } label: {
                HStack {
                    Image(systemName: "gear")
                    Text("Open Settings")
                }
            }
            .claudeSecondaryButton()
        }
        .claudeCard(padding: 32)
    }

    // MARK: - Spin Animation

    private func spinWithAnimation() {
        guard subscriptionManager.canSpin() else {
            showPaywall = true
            return
        }

        // Initial haptic
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        subscriptionManager.recordSpin()

        // Start metronome animation
        withAnimation(.easeInOut(duration: 0.3)) {
            isSpinning = true
        }

        // Mid-animation haptic (1.25s is the metronome cycle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        // Actually pick the contact mid-animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            vm.spin()

            // Reset conversation starter for new contact
            conversationStarter = ConversationStarters.random()
            showConversationStarter = false
        }

        // End animation with success haptic (2.5 seconds total)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)

            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isSpinning = false
            }

            // Show notification prompt after first spin
            if !hasShownFirstSpinPrompt && !notificationManager.isAuthorized {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showNotificationPrompt = true
                    hasShownFirstSpinPrompt = true
                    UserDefaults.standard.set(true, forKey: "hasShownFirstSpinPrompt")
                }
            }
        }
    }

    // MARK: - Helper

    private func formatPhone(_ phone: String) -> String {
        let d = phone
        if d.count == 10 {
            let a = d.prefix(3), b = d.dropFirst(3).prefix(3), c = d.suffix(4)
            return "(\(a)) \(b)-\(c)"
        }
        return d
    }

    private func formatRefillTime(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInTomorrow(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "tomorrow at \(formatter.string(from: date))"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}
