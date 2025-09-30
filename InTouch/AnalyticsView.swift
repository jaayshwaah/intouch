import SwiftUI

struct AnalyticsView: View {
    @State private var analytics = ContactAnalytics.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        monthlyStats
                        
                        achievements
                        
                        topContacts
                        
                        rareContacts
                        
                        smartSuggestions
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
            }
            .navigationTitle("Analytics")
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
    }
    
    // MARK: - Monthly Stats
    
    private var monthlyStats: some View {
        let stats = analytics.getMonthlyStats()
        
        return GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    Text("This Month")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    StatCard(
                        title: "Contacts",
                        value: "\(stats.totalContacts)",
                        subtitle: "Total",
                        color: .blue
                    )
                    
                    StatCard(
                        title: "People",
                        value: "\(stats.uniqueContacts)",
                        subtitle: "Unique",
                        color: .green
                    )
                    
                    StatCard(
                        title: "Goal",
                        value: "\(stats.goal)",
                        subtitle: stats.isGoalMet ? "Met! 🎉" : "Remaining: \(stats.goal - stats.totalContacts)",
                        color: stats.isGoalMet ? .green : .orange
                    )
                }
                
                if !stats.isGoalMet {
                    ProgressView(value: Double(stats.totalContacts), total: Double(stats.goal))
                        .tint(.blue)
                        .scaleEffect(y: 2)
                }
            }
        }
    }
    
    // MARK: - Achievements
    
    private var achievements: some View {
        let unlockedAchievements = analytics.getUnlockedAchievements()
        
        return GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    Text("Achievements")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("\(unlockedAchievements.count)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.2), in: Capsule())
                }
                
                if unlockedAchievements.isEmpty {
                    Text("Complete contacts to unlock achievements!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(unlockedAchievements.prefix(6)) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Top Contacts
    
    private var topContacts: some View {
        let topContacts = analytics.getTopContacts(limit: 5)
        
        return GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "person.3.fill")
                        .font(.title2)
                        .foregroundStyle(.purple)
                    
                    Text("Most Contacted")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
                if topContacts.isEmpty {
                    Text("Start making contacts to see your top people!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(Array(topContacts.enumerated()), id: \.element.contactId) { index, contact in
                        ContactStatRow(
                            rank: index + 1,
                            name: contact.contactName,
                            count: contact.totalContacts,
                            streak: contact.streak
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Rare Contacts
    
    private var rareContacts: some View {
        let rareContacts = analytics.getRareContacts()
        
        return GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    
                    Text("Haven't Talked In A While")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
                if rareContacts.isEmpty {
                    Text("Great job staying in touch with everyone!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(Array(rareContacts.prefix(3).enumerated()), id: \.offset) { _, contact in
                        RareContactRow(contact: contact)
                    }
                }
            }
        }
    }
    
    // MARK: - Smart Suggestions
    
    private var smartSuggestions: some View {
        let suggestions = analytics.getSmartSuggestions()
        
        return GlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    Text("Smart Suggestions")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                
                if suggestions.isEmpty {
                    Text("Keep making contacts for personalized suggestions!")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(Array(suggestions.prefix(3).enumerated()), id: \.offset) { _, suggestion in
                        SuggestionRow(suggestion: suggestion)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title.weight(.bold))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct AchievementCard: View {
    let achievement: ContactAnalytics.Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundStyle(.yellow)
            
            Text(achievement.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ContactStatRow: View {
    let rank: Int
    let name: String
    let count: Int
    let streak: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(.white.opacity(0.2), in: Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                
                Text("\(count) contacts")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            if streak > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    
                    Text("\(streak)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.orange.opacity(0.2), in: Capsule())
            }
        }
    }
}

struct RareContactRow: View {
    let contact: ContactAnalytics.ContactFrequency
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundStyle(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.contactName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                
                if let lastContact = contact.lastContact {
                    let daysSince = Calendar.current.dateComponents([.day], from: lastContact, to: Date()).day ?? 0
                    Text("\(daysSince) days ago")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Button("Reach Out") {
                // This would trigger a contact action
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.orange, in: Capsule())
        }
    }
}

struct SuggestionRow: View {
    let suggestion: ContactAnalytics.SmartSuggestion
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: suggestionIcon)
                .font(.title3)
                .foregroundStyle(suggestionColor)
            
            Text(suggestion.message)
                .font(.subheadline)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(suggestionColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(suggestionColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var suggestionIcon: String {
        switch suggestion.type {
        case .longTimeNoSee: return "clock.fill"
        case .maintainStreak: return "flame.fill"
        case .monthlyGoal: return "target"
        case .birthday: return "gift.fill"
        }
    }
    
    private var suggestionColor: Color {
        switch suggestion.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}

#Preview {
    AnalyticsView()
}
