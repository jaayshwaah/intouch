import Foundation
import UserNotifications
import Observation

@Observable
@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    var isAuthorized = false
    var notificationTime: Date {
        didSet {
            saveNotificationTime()
            scheduleNotification()
        }
    }

    private let notificationTimeKey = "dailyNotificationTime"
    private let notificationIdentifier = "daily_spin_reminder"

    private init() {
        // Default to 7pm
        let calendar = Calendar.current
        let components = DateComponents(hour: 19, minute: 0)
        self.notificationTime = calendar.date(from: components) ?? Date()

        loadNotificationTime()
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted

            if granted {
                scheduleNotification()
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

    func scheduleNotification() {
        // Remove existing notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [notificationIdentifier]
        )

        guard isAuthorized else { return }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Time to reconnect!"
        content.body = "Spin to see who you should reach out to today 🎲"
        content.sound = .default
        content.badge = 1

        // Schedule for the specified time daily
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    // MARK: - Persistence

    private func loadNotificationTime() {
        if let timestamp = UserDefaults.standard.object(forKey: notificationTimeKey) as? TimeInterval {
            notificationTime = Date(timeIntervalSince1970: timestamp)
        }
    }

    private func saveNotificationTime() {
        UserDefaults.standard.set(notificationTime.timeIntervalSince1970, forKey: notificationTimeKey)
    }
}
