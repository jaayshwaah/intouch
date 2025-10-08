import SwiftUI
import UserNotifications

@main
struct InTouchApp: App {
    @State private var notificationManager = NotificationManager.shared

    init() {
        // Configure notification delegate
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            RandomContactView()
                .onAppear {
                    // Clear badge when app opens
                    UNUserNotificationCenter.current().setBadgeCount(0)
                }
        }
    }
}

// Notification delegate to handle notifications when app is in foreground
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
    }

    // Show notification even when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // App will open to main view automatically
        completionHandler()
    }
}
