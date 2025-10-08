import Foundation
import UIKit
import UserNotifications
import Observation

@Observable
@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    var isAuthorized = false
    var notificationsEnabled = true {
        didSet {
            saveNotificationsEnabled()
            if notificationsEnabled {
                scheduleNotifications()
            } else {
                cancelAllNotifications()
            }
        }
    }

    private let notificationsEnabledKey = "notificationsEnabled"
    private let morningNotificationIdentifier = "morning_spin_refill"
    private let afternoonNotificationIdentifier = "afternoon_spin_refill"

    // Legacy - keeping for backwards compatibility
    var notificationTime: Date {
        let calendar = Calendar.current
        let components = DateComponents(hour: 7, minute: 0)
        return calendar.date(from: components) ?? Date()
    }

    private init() {
        notificationsEnabled = UserDefaults.standard.object(forKey: notificationsEnabledKey) as? Bool ?? true
        Task {
            await checkAuthorizationStatus()
            if isAuthorized && notificationsEnabled {
                scheduleNotifications()
            }
        }
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted

            if granted && notificationsEnabled {
                scheduleNotifications()
            }

            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Scheduling

    func scheduleNotifications() {
        // Remove existing notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [morningNotificationIdentifier, afternoonNotificationIdentifier]
        )

        guard isAuthorized && notificationsEnabled else { return }

        // Morning notification (7am)
        scheduleMorningNotification()

        // Afternoon notification (4pm)
        scheduleAfternoonNotification()
    }

    private func scheduleMorningNotification() {
        let content = UNMutableNotificationContent()

        // Rotate between compelling morning CTAs
        let morningMessages = [
            ("Who misses you?", "Spin now to find out who you should call today ☀️"),
            ("3 new spins unlocked!", "Someone's waiting to hear from you. Tap to spin 🎯"),
            ("Make someone's day", "You have 3 spins. Who will you reconnect with? 💛"),
            ("Don't let them forget you", "Spin now before your spins expire at 4pm ⏰"),
            ("Reconnect in 30 seconds", "Tap to spin and strengthen a relationship today 🤝")
        ]

        let randomIndex = Int.random(in: 0..<morningMessages.count)
        let (title, body) = morningMessages[randomIndex]

        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "SPIN_REMINDER"

        var components = DateComponents()
        components.hour = 7
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: morningNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error)")
            }
        }
    }

    private func scheduleAfternoonNotification() {
        let content = UNMutableNotificationContent()

        // Rotate between compelling afternoon CTAs
        let afternoonMessages = [
            ("Last chance today!", "3 fresh spins expire at midnight. Spin now 🌙"),
            ("Who did you forget to call?", "Your afternoon spins are ready. Make it count 📞"),
            ("3 more chances", "Reconnect before the day ends. Tap to spin now ✨"),
            ("Your evening spins arrived", "Someone needs to hear from you. Ready to spin? 💬"),
            ("Turn 30 seconds into a memory", "Spin and surprise someone with a call tonight 🎉")
        ]

        let randomIndex = Int.random(in: 0..<afternoonMessages.count)
        let (title, body) = afternoonMessages[randomIndex]

        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "SPIN_REMINDER"

        var components = DateComponents()
        components.hour = 16 // 4pm
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: afternoonNotificationIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling afternoon notification: \(error)")
            }
        }
    }

    // Legacy method for backwards compatibility
    func scheduleNotification() {
        scheduleNotifications()
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    // MARK: - Persistence

    private func saveNotificationsEnabled() {
        UserDefaults.standard.set(notificationsEnabled, forKey: notificationsEnabledKey)
    }
}
