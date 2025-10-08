import SwiftUI

struct AnalyticsView: View {
    @State private var analytics = ContactAnalytics.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    monthlyStats
                        .claudeColumnLayout()

                    achievements
                        .claudeColumnLayout()

                    topContacts
                        .claudeColumnLayout()

                    rareContacts
                        .claudeColumnLayout()

                    Spacer(minLength: 40)
                }
                .padding(.vertical, 20)
            }
            .background(ClaudeBackground().ignoresSafeArea())
            .navigationTitle("Analytics")
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
    }

    // MARK: - Monthly Stats

    private var monthlyStats: some View {
        let stats = analytics.getMonthlyStats()

        return VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(ClaudeColors.claudeOrange)
                Text("This Month")
                    .font(ClaudeTypography.title2Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            HStack(spacing: 12) {
                statCard(
                    value: "\(stats.uniqueContacts)",
                    label: "Unique Contacts",
                    icon: "person.fill"
                )

                statCard(
                    value: "\(stats.totalContacts)",
                    label: "Total Interactions",
                    icon: "bubble.left.and.bubble.right.fill"
                )
            }

            // Goal Progress
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Monthly Goal")
                        .font(ClaudeTypography.calloutFont)
                        .foregroundStyle(ClaudeColors.charcoal)
                    Spacer()
                    Text("\(stats.totalContacts)/\(stats.goal)")
                        .font(ClaudeTypography.calloutFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(stats.isGoalMet ? ClaudeColors.softGreen : ClaudeColors.claudeOrange)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(ClaudeColors.border)
                            .frame(height: 12)

                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: stats.isGoalMet ?
                                        [ClaudeColors.softGreen, ClaudeColors.softGreen.opacity(0.7)] :
                                        [ClaudeColors.claudeOrange, ClaudeColors.claudeOrangeDark],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: min(CGFloat(stats.totalContacts) / CGFloat(stats.goal), 1.0) * geometry.size.width,
                                height: 12
                            )
                    }
                }
                .frame(height: 12)
            }
        }
        .claudeCard(padding: 24)
    }

    private func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(ClaudeColors.claudeOrange)

            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(ClaudeColors.charcoal)

            Text(label)
                .font(ClaudeTypography.captionFont)
                .foregroundStyle(ClaudeColors.mediumGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(ClaudeColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ClaudeColors.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Achievements

    private var achievements: some View {
        let unlocked = analytics.getUnlockedAchievements()

        if unlocked.isEmpty {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(ClaudeColors.claudeOrange)
                    Text("Achievements")
                        .font(ClaudeTypography.title2Font)
                        .foregroundStyle(ClaudeColors.charcoal)
                }

                VStack(spacing: 12) {
                    ForEach(Array(unlocked.prefix(5))) { achievement in
                        achievementRow(achievement)
                    }
                }
            }
            .claudeCard(padding: 24)
        )
    }

    private func achievementRow(_ achievement: ContactAnalytics.Achievement) -> some View {
        HStack(spacing: 14) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundStyle(ClaudeColors.claudeOrange)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(ClaudeColors.claudeOrange.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(ClaudeTypography.calloutFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(ClaudeColors.charcoal)

                Text(achievement.description)
                    .font(ClaudeTypography.footnoteFont)
                    .foregroundStyle(ClaudeColors.mediumGray)
            }

            Spacer()
        }
    }

    // MARK: - Top Contacts

    private var topContacts: some View {
        let top = analytics.getTopContacts(limit: 5)

        if top.isEmpty {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(ClaudeColors.claudeOrange)
                    Text("Top Contacts")
                        .font(ClaudeTypography.title2Font)
                        .foregroundStyle(ClaudeColors.charcoal)
                }

                VStack(spacing: 12) {
                    ForEach(Array(top.enumerated()), id: \.element.contactId) { index, contact in
                        contactFrequencyRow(contact, rank: index + 1)
                    }
                }
            }
            .claudeCard(padding: 24)
        )
    }

    // MARK: - Rare Contacts

    private var rareContacts: some View {
        let rare = Array(analytics.getRareContacts().prefix(5))

        if rare.isEmpty {
            return AnyView(EmptyView())
        }

        return AnyView(
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(ClaudeColors.warmRed)
                    Text("Haven't Connected Recently")
                        .font(ClaudeTypography.title2Font)
                        .foregroundStyle(ClaudeColors.charcoal)
                }

                Text("These contacts haven't appeared in your spins for over 30 days")
                    .font(ClaudeTypography.subheadlineFont)
                    .foregroundStyle(ClaudeColors.mediumGray)

                VStack(spacing: 12) {
                    ForEach(rare, id: \.contactId) { contact in
                        rareContactRow(contact)
                    }
                }
            }
            .claudeCard(padding: 24)
        )
    }

    // MARK: - Row Components

    private func contactFrequencyRow(_ frequency: ContactAnalytics.ContactFrequency, rank: Int) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(ClaudeColors.claudeOrange.opacity(0.1))
                    .frame(width: 36, height: 36)

                Text("\(rank)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(ClaudeColors.claudeOrange)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(frequency.contactName)
                    .font(ClaudeTypography.calloutFont)
                    .foregroundStyle(ClaudeColors.charcoal)

                Text("\(frequency.totalContacts) interactions")
                    .font(ClaudeTypography.footnoteFont)
                    .foregroundStyle(ClaudeColors.mediumGray)
            }

            Spacer()

            if frequency.streak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(ClaudeColors.claudeOrange)
                    Text("\(frequency.streak)")
                        .font(ClaudeTypography.captionFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(ClaudeColors.claudeOrange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(ClaudeColors.claudeOrange.opacity(0.1))
                )
            }
        }
        .padding(14)
        .background(ClaudeColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ClaudeColors.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func rareContactRow(_ frequency: ContactAnalytics.ContactFrequency) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(ClaudeColors.mediumGray)

            VStack(alignment: .leading, spacing: 4) {
                Text(frequency.contactName)
                    .font(ClaudeTypography.calloutFont)
                    .foregroundStyle(ClaudeColors.charcoal)

                if let lastContact = frequency.lastContact {
                    let days = Calendar.current.dateComponents([.day], from: lastContact, to: Date()).day ?? 0
                    Text("\(days) days ago")
                        .font(ClaudeTypography.footnoteFont)
                        .foregroundStyle(ClaudeColors.warmRed)
                }
            }

            Spacer()
        }
        .padding(14)
        .background(ClaudeColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ClaudeColors.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
