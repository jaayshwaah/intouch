import SwiftUI

struct SettingsView: View {
    @State private var notificationManager = NotificationManager.shared
    @State private var subscriptionManager = SubscriptionManager.shared
    @Bindable var viewModel: RandomContactViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showingPaywall = false
    @State private var showingManageExclusions = false
    @State private var showResetSeenAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    ClaudeBackground()
                        .ignoresSafeArea()

                    VStack(spacing: 24) {
                        // Notifications Section
                        notificationsSection
                            .claudeColumnLayout()

                        // Contact Settings
                        contactSettingsSection
                            .claudeColumnLayout()

                        // Subscription Section
                        subscriptionSection
                            .claudeColumnLayout()

                        // About Section
                        aboutSection
                            .claudeColumnLayout()

                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 20)
                }
            }
            .background(ClaudeBackground().ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(ClaudeTypography.calloutFont)
                    .foregroundStyle(ClaudeColors.claudeOrange)
                }
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showingManageExclusions) {
            NavigationStack {
                ManageExclusionsView(vm: viewModel)
            }
        }
        .alert("Clear Seen History?", isPresented: $showResetSeenAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                viewModel.clearSeenHistory()
            }
        } message: {
            Text("This will allow you to see all contacts again in future spins.")
        }
    }

    // MARK: - Notifications Section

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack(spacing: 10) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(ClaudeColors.claudeOrange)
                Text("Daily Reminders")
                    .font(ClaudeTypography.title3Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            if notificationManager.isAuthorized {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Get a daily reminder to stay in touch with your contacts")
                        .font(ClaudeTypography.bodyFont)
                        .foregroundStyle(ClaudeColors.mediumGray)

                    VStack(spacing: 0) {
                        HStack {
                            Text("Reminder Time")
                                .font(ClaudeTypography.calloutFont)
                                .foregroundStyle(ClaudeColors.charcoal)
                            Spacer()
                            DatePicker(
                                "",
                                selection: $notificationManager.notificationTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .tint(ClaudeColors.claudeOrange)
                        }
                        .padding(16)
                        .background(ClaudeColors.warmWhite)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ClaudeColors.border, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Enable notifications to get daily reminders to reconnect")
                        .font(ClaudeTypography.bodyFont)
                        .foregroundStyle(ClaudeColors.mediumGray)

                    Button {
                        Task {
                            let granted = await notificationManager.requestAuthorization()
                            if !granted {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    notificationManager.openSettings()
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                            Text("Enable Notifications")
                        }
                    }
                    .claudePrimaryButton()
                }
            }
        }
        .claudeCard()
    }

    // MARK: - Contact Settings Section

    private var contactSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(ClaudeColors.claudeOrange)
                Text("Contact Preferences")
                    .font(ClaudeTypography.title3Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            VStack(spacing: 0) {
                // No Repeats Toggle
                settingRow {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No Repeats (Ever)")
                                .font(ClaudeTypography.calloutFont)
                                .foregroundStyle(ClaudeColors.charcoal)
                            Text("Never show the same contact twice")
                                .font(ClaudeTypography.footnoteFont)
                                .foregroundStyle(ClaudeColors.mediumGray)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { viewModel.noRepeatsEver },
                            set: { viewModel.setNoRepeatsEver($0) }
                        ))
                        .tint(ClaudeColors.claudeOrange)
                    }
                }

                ClaudeDivider()

                // Manage Exclusions
                settingRow {
                    Button {
                        showingManageExclusions = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Manage Exclusions")
                                    .font(ClaudeTypography.calloutFont)
                                    .foregroundStyle(ClaudeColors.charcoal)
                                Text("Hide specific contacts from spins")
                                    .font(ClaudeTypography.footnoteFont)
                                    .foregroundStyle(ClaudeColors.mediumGray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(ClaudeColors.lightGray)
                        }
                    }
                }

                ClaudeDivider()

                // Clear History
                settingRow {
                    Button {
                        showResetSeenAlert = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Clear Seen History")
                                    .font(ClaudeTypography.calloutFont)
                                    .foregroundStyle(ClaudeColors.warmRed)
                                Text("Reset all previously seen contacts")
                                    .font(ClaudeTypography.footnoteFont)
                                    .foregroundStyle(ClaudeColors.mediumGray)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .background(ClaudeColors.warmWhite)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ClaudeColors.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .claudeCard()
    }

    // MARK: - Subscription Section

    private var subscriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(ClaudeColors.claudeOrange)
                Text("Subscription")
                    .font(ClaudeTypography.title3Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            if subscriptionManager.isSubscribed {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(ClaudeColors.softGreen)
                        Text("Premium Active")
                            .font(ClaudeTypography.calloutFont)
                            .foregroundStyle(ClaudeColors.charcoal)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ClaudeColors.softGreen.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ClaudeColors.softGreen.opacity(0.3), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    Button {
                        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                            Text("Manage Subscription")
                        }
                    }
                    .claudeSecondaryButton()
                }
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Upgrade to Premium")
                        .font(ClaudeTypography.calloutFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(ClaudeColors.charcoal)

                    VStack(alignment: .leading, spacing: 10) {
                        featureBullet("Unlimited daily spins")
                        featureBullet("Multiple daily reminders", isComingSoon: true)
                        featureBullet("Custom contact lists", isComingSoon: true)
                    }

                    Button {
                        showingPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                            Text("See Premium Options")
                        }
                    }
                    .claudePrimaryButton()
                }
            }
        }
        .claudeCard()
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(ClaudeColors.claudeOrange)
                Text("About")
                    .font(ClaudeTypography.title3Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            VStack(spacing: 0) {
                HStack {
                    Text("Version")
                        .font(ClaudeTypography.calloutFont)
                        .foregroundStyle(ClaudeColors.charcoal)
                    Spacer()
                    Text("1.0")
                        .font(ClaudeTypography.calloutFont)
                        .foregroundStyle(ClaudeColors.mediumGray)
                }
                .padding(16)

                ClaudeDivider()

                Button {
                    if let url = URL(string: "https://jaayshwaah.github.io/intouch/privacy") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text("Privacy Policy")
                            .font(ClaudeTypography.calloutFont)
                            .foregroundStyle(ClaudeColors.charcoal)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(ClaudeColors.lightGray)
                    }
                    .padding(16)
                }

                ClaudeDivider()

                Button {
                    if let url = URL(string: "mailto:support@intouch.app") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text("Contact Support")
                            .font(ClaudeTypography.calloutFont)
                            .foregroundStyle(ClaudeColors.charcoal)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(ClaudeColors.lightGray)
                    }
                    .padding(16)
                }
            }
            .background(ClaudeColors.warmWhite)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ClaudeColors.border, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .claudeCard()
    }

    // MARK: - Helper Views

    private func settingRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
    }

    private func featureBullet(_ text: String, isComingSoon: Bool = false) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundStyle(ClaudeColors.claudeOrange)
            Text(text)
                .font(ClaudeTypography.subheadlineFont)
                .foregroundStyle(ClaudeColors.charcoal)
            if isComingSoon {
                ClaudeBadge("Soon", color: ClaudeColors.mediumGray)
            }
        }
    }
}
