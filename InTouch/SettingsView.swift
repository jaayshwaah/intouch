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
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(spacing: 20) {
                        // Notifications Section
                        notificationsSection
                            .centerColumnAdaptive()

                        // Contact Settings
                        contactSettingsSection
                            .centerColumnAdaptive()

                        // Subscription Section
                        subscriptionSection
                            .centerColumnAdaptive()

                        // About Section
                        aboutSection
                            .centerColumnAdaptive()

                        Spacer(minLength: 24)
                    }
                    .safeAreaPadding(.vertical, 10)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
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

    // MARK: - Sections

    private var notificationsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Daily Reminder", systemImage: "bell.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)

                if notificationManager.isAuthorized {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Get a daily reminder to stay in touch")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.5), radius: 1, y: 0.5)

                        DatePicker(
                            "Reminder Time",
                            selection: $notificationManager.notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                        .foregroundStyle(.white)
                        .tint(.white)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enable notifications to get daily reminders")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.5), radius: 1, y: 0.5)

                        Button {
                            Task {
                                let granted = await notificationManager.requestAuthorization()
                                if !granted {
                                    // If denied, open settings
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        notificationManager.openSettings()
                                    }
                                }
                            }
                        } label: {
                            Label("Enable Notifications", systemImage: "bell.badge.fill")
                        }
                        .glass()
                    }
                }
            }
        }
    }

    private var contactSettingsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Contact Preferences", systemImage: "person.2.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)

                VStack(spacing: 12) {
                    Toggle(isOn: Binding(
                        get: { viewModel.noRepeatsEver },
                        set: { viewModel.setNoRepeatsEver($0) }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("No Repeats (Ever)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                            Text("Never show the same contact twice")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .tint(.white)

                    Divider()
                        .background(.white.opacity(0.3))

                    Button {
                        showingManageExclusions = true
                    } label: {
                        HStack {
                            Label("Manage Exclusions", systemImage: "person.crop.circle.badge.xmark")
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }

                    Divider()
                        .background(.white.opacity(0.3))

                    Button(role: .destructive) {
                        showResetSeenAlert = true
                    } label: {
                        Label("Clear Seen History", systemImage: "clock.arrow.circlepath")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
    }

    private var subscriptionSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Subscription", systemImage: "crown.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)

                if subscriptionManager.isSubscribed {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Premium Active")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                        }

                        Button {
                            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Manage Subscription", systemImage: "gear")
                        }
                        .glass()
                    }
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upgrade to Premium")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)

                        Text("• Unlimited spins per day\n• Multiple daily reminders (coming soon)\n• Custom contact lists (coming soon)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))

                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("See Premium Options")
                            }
                        }
                        .glassProminent()
                    }
                }
            }
        }
    }

    private var aboutSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("About", systemImage: "info.circle.fill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, y: 1)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Version")
                            .foregroundStyle(.white.opacity(0.8))
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.white)
                    }
                    .font(.subheadline)

                    Divider()
                        .background(.white.opacity(0.3))

                    Button {
                        if let url = URL(string: "mailto:support@intouch.app") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Label("Contact Support", systemImage: "envelope.fill")
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }
        }
    }
}
