import Foundation
import Observation

@Observable
@MainActor
final class ContactAnalytics {
    static let shared = ContactAnalytics()
    
    // Contact tracking data
    private var contactHistory: [String: [ContactEvent]] = [:]
    private var dailyStreaks: [String: Int] = [:]
    private var monthlyGoals: [String: Int] = [:]
    private var achievements: Set<Achievement> = []
    
    // UserDefaults keys
    private let contactHistoryKey = "contactHistory_v1"
    private let dailyStreaksKey = "dailyStreaks_v1"
    private let monthlyGoalsKey = "monthlyGoals_v1"
    private let achievementsKey = "achievements_v1"
    
    // Current month tracking
    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: Date())
    }
    
    private init() {
        loadPersistedData()
    }
    
    // MARK: - Contact Event Tracking
    
    struct ContactEvent: Codable, Identifiable {
        let id = UUID()
        let contactId: String
        let contactName: String
        let type: ContactType
        let timestamp: Date
        
        enum ContactType: String, Codable, CaseIterable {
            case call = "call"
            case text = "text"
            case spin = "spin"
        }
    }
    
    func recordContact(_ contactId: String, name: String, type: ContactEvent.ContactType) {
        let event = ContactEvent(
            contactId: contactId,
            contactName: name,
            type: type,
            timestamp: Date()
        )
        
        if contactHistory[contactId] == nil {
            contactHistory[contactId] = []
        }
        contactHistory[contactId]?.append(event)
        
        // Update daily streak
        updateDailyStreak(for: contactId)
        
        // Update monthly goal
        updateMonthlyGoal()
        
        // Check for achievements
        checkAchievements()
        
        persistData()
    }
    
    // MARK: - Analytics Data
    
    func getContactFrequency(for contactId: String) -> ContactFrequency {
        let events = contactHistory[contactId] ?? []
        let now = Date()
        let calendar = Calendar.current
        
        let last7Days = events.filter { calendar.dateInterval(of: .weekOfYear, for: $0.timestamp)?.contains(now) == true }
        let last30Days = events.filter { calendar.dateInterval(of: .month, for: $0.timestamp)?.contains(now) == true }
        
        let lastContact = events.last?.timestamp
        
        return ContactFrequency(
            totalContacts: events.count,
            last7Days: last7Days.count,
            last30Days: last30Days.count,
            lastContact: lastContact,
            streak: dailyStreaks[contactId] ?? 0
        )
    }
    
    func getMonthlyStats() -> MonthlyStats {
        let currentMonthEvents = contactHistory.values.flatMap { $0 }
            .filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .month) }
        
        let uniqueContacts = Set(currentMonthEvents.map { $0.contactId }).count
        let totalContacts = currentMonthEvents.count
        
        return MonthlyStats(
            uniqueContacts: uniqueContacts,
            totalContacts: totalContacts,
            goal: monthlyGoals[currentMonth] ?? 10,
            isGoalMet: totalContacts >= (monthlyGoals[currentMonth] ?? 10)
        )
    }
    
    func getTopContacts(limit: Int = 5) -> [ContactFrequency] {
        return contactHistory.keys.compactMap { contactId in
            let events = contactHistory[contactId] ?? []
            guard !events.isEmpty else { return nil }
            
            let frequency = getContactFrequency(for: contactId)
            return frequency
        }
        .sorted { $0.totalContacts > $1.totalContacts }
        .prefix(limit)
        .map { $0 }
    }
    
    func getRareContacts() -> [ContactFrequency] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        
        return contactHistory.keys.compactMap { contactId in
            let events = contactHistory[contactId] ?? []
            let recentEvents = events.filter { $0.timestamp > thirtyDaysAgo }
            
            guard recentEvents.isEmpty else { return nil }
            
            let frequency = getContactFrequency(for: contactId)
            return frequency
        }
        .sorted { ($0.lastContact ?? Date.distantPast) < ($1.lastContact ?? Date.distantPast) }
    }
    
    // MARK: - Streaks and Goals
    
    private func updateDailyStreak(for contactId: String) {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        
        let events = contactHistory[contactId] ?? []
        let todayEvents = events.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
        let yesterdayEvents = events.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: yesterday) }
        
        if !todayEvents.isEmpty {
            if !yesterdayEvents.isEmpty {
                dailyStreaks[contactId] = (dailyStreaks[contactId] ?? 0) + 1
            } else {
                dailyStreaks[contactId] = 1
            }
        }
    }
    
    private func updateMonthlyGoal() {
        let currentGoal = monthlyGoals[currentMonth] ?? 10
        let currentContacts = getMonthlyStats().totalContacts
        
        if currentContacts >= currentGoal {
            // Goal met, increase for next month
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            let nextMonthKey = formatter.string(from: nextMonth)
            monthlyGoals[nextMonthKey] = currentGoal + 5
        }
    }
    
    func setMonthlyGoal(_ goal: Int) {
        monthlyGoals[currentMonth] = goal
        persistData()
    }
    
    // MARK: - Achievements
    
    struct Achievement: Codable, Identifiable, Hashable {
        let id: String
        let title: String
        let description: String
        let icon: String
        let isUnlocked: Bool
        let unlockedAt: Date?
        
        init(id: String, title: String, description: String, icon: String, isUnlocked: Bool = false, unlockedAt: Date? = nil) {
            self.id = id
            self.title = title
            self.description = description
            self.icon = icon
            self.isUnlocked = isUnlocked
            self.unlockedAt = unlockedAt
        }
    }
    
    private func checkAchievements() {
        let stats = getMonthlyStats()
        let allContacts = contactHistory.values.flatMap { $0 }
        
        // First Contact Achievement
        if allContacts.count == 1 && !achievements.contains(where: { $0.id == "first_contact" }) {
            unlockAchievement("first_contact", "First Contact", "Made your first contact!", "hand.wave.fill")
        }
        
        // Streak Achievements
        let maxStreak = dailyStreaks.values.max() ?? 0
        if maxStreak >= 7 && !achievements.contains(where: { $0.id == "week_streak" }) {
            unlockAchievement("week_streak", "Week Warrior", "7-day contact streak!", "flame.fill")
        }
        
        if maxStreak >= 30 && !achievements.contains(where: { $0.id == "month_streak" }) {
            unlockAchievement("month_streak", "Streak Master", "30-day contact streak!", "flame.circle.fill")
        }
        
        // Goal Achievements
        if stats.isGoalMet && !achievements.contains(where: { $0.id == "goal_met" }) {
            unlockAchievement("goal_met", "Goal Crusher", "Met your monthly goal!", "target")
        }
        
        // Social Achievements
        if stats.uniqueContacts >= 10 && !achievements.contains(where: { $0.id == "social_butterfly" }) {
            unlockAchievement("social_butterfly", "Social Butterfly", "Contacted 10+ people this month!", "person.3.fill")
        }
        
        if stats.totalContacts >= 50 && !achievements.contains(where: { $0.id == "contact_champion" }) {
            unlockAchievement("contact_champion", "Contact Champion", "50+ contacts this month!", "crown.fill")
        }
    }
    
    private func unlockAchievement(_ id: String, _ title: String, _ description: String, _ icon: String) {
        let achievement = Achievement(
            id: id,
            title: title,
            description: description,
            icon: icon,
            isUnlocked: true,
            unlockedAt: Date()
        )
        achievements.insert(achievement)
    }
    
    func getUnlockedAchievements() -> [Achievement] {
        return Array(achievements).filter { $0.isUnlocked }.sorted { 
            ($0.unlockedAt ?? Date.distantPast) > ($1.unlockedAt ?? Date.distantPast) 
        }
    }
    
    func getRecentAchievements() -> [Achievement] {
        let recent = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return getUnlockedAchievements().filter { 
            ($0.unlockedAt ?? Date.distantPast) > recent 
        }
    }
    
    // MARK: - Smart Suggestions
    
    func getSmartSuggestions() -> [SmartSuggestion] {
        var suggestions: [SmartSuggestion] = []
        
        // Haven't talked in a while
        let rareContacts = getRareContacts()
        for contact in rareContacts.prefix(3) {
            if let lastContact = contact.lastContact {
                let daysSince = Calendar.current.dateComponents([.day], from: lastContact, to: Date()).day ?? 0
                suggestions.append(SmartSuggestion(
                    type: .longTimeNoSee,
                    contactId: contact.contactId,
                    contactName: contact.contactName,
                    message: "Haven't talked to \(contact.contactName) in \(daysSince) days",
                    priority: .high
                ))
            }
        }
        
        // Birthday reminders (if we had birthday data)
        // This would require adding birthday to ContactRecord
        
        // Streak maintenance
        let activeStreaks = dailyStreaks.filter { $0.value > 0 }
        for (contactId, streak) in activeStreaks {
            if let contact = contactHistory[contactId]?.first {
                suggestions.append(SmartSuggestion(
                    type: .maintainStreak,
                    contactId: contactId,
                    contactName: contact.contactName,
                    message: "Keep your \(streak)-day streak with \(contact.contactName)",
                    priority: .medium
                ))
            }
        }
        
        // Monthly goal progress
        let stats = getMonthlyStats()
        if !stats.isGoalMet {
            let remaining = stats.goal - stats.totalContacts
            suggestions.append(SmartSuggestion(
                type: .monthlyGoal,
                contactId: "",
                contactName: "",
                message: "\(remaining) more contacts to reach your monthly goal!",
                priority: .low
            ))
        }
        
        return suggestions.sorted { $0.priority.rawValue < $1.priority.rawValue }
    }
    
    // MARK: - Data Structures
    
    struct ContactFrequency {
        let contactId: String
        let contactName: String
        let totalContacts: Int
        let last7Days: Int
        let last30Days: Int
        let lastContact: Date?
        let streak: Int
        
        init(contactId: String = "", contactName: String = "", totalContacts: Int, last7Days: Int, last30Days: Int, lastContact: Date?, streak: Int) {
            self.contactId = contactId
            self.contactName = contactName
            self.totalContacts = totalContacts
            self.last7Days = last7Days
            self.last30Days = last30Days
            self.lastContact = lastContact
            self.streak = streak
        }
    }
    
    struct MonthlyStats {
        let uniqueContacts: Int
        let totalContacts: Int
        let goal: Int
        let isGoalMet: Bool
    }
    
    struct SmartSuggestion {
        let type: SuggestionType
        let contactId: String
        let contactName: String
        let message: String
        let priority: Priority
        
        enum SuggestionType {
            case longTimeNoSee
            case maintainStreak
            case monthlyGoal
            case birthday
        }
        
        enum Priority: Int, CaseIterable {
            case high = 1
            case medium = 2
            case low = 3
        }
    }
    
    // MARK: - Persistence
    
    private func loadPersistedData() {
        if let data = UserDefaults.standard.data(forKey: contactHistoryKey),
           let decoded = try? JSONDecoder().decode([String: [ContactEvent]].self, from: data) {
            contactHistory = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: dailyStreaksKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            dailyStreaks = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: monthlyGoalsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            monthlyGoals = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode(Set<Achievement>.self, from: data) {
            achievements = decoded
        }
    }
    
    private func persistData() {
        if let data = try? JSONEncoder().encode(contactHistory) {
            UserDefaults.standard.set(data, forKey: contactHistoryKey)
        }
        
        if let data = try? JSONEncoder().encode(dailyStreaks) {
            UserDefaults.standard.set(data, forKey: dailyStreaksKey)
        }
        
        if let data = try? JSONEncoder().encode(monthlyGoals) {
            UserDefaults.standard.set(data, forKey: monthlyGoalsKey)
        }
        
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: achievementsKey)
        }
    }
}
