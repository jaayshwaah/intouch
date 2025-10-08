# InTouch - Implementation Notes

Quick reference for developers working on the codebase.

## Architecture Overview

### MVVM Pattern
- **Views**: SwiftUI views (RandomContactView, SettingsView, etc.)
- **ViewModels**: Observable classes (RandomContactViewModel)
- **Models**: Simple structs (ContactRecord, LabeledPhone)
- **Managers**: Singleton services (SubscriptionManager, NotificationManager, ContactAnalytics)

### State Management
- **@Observable** macro for ViewModels (iOS 17+)
- **@State** for local view state
- **UserDefaults** for persistence
- **Shared singletons** for cross-app state

## Key Components

### 1. Contact Management

**ContactFetcher.swift**
- Handles Contacts framework integration
- Async/await for permission requests
- Background thread for heavy enumeration
- Smart phone number sorting (mobile preferred)

```swift
// Usage
let fetcher = ContactFetcher()
try await fetcher.requestAccessIfNeeded()
let contacts = try await fetcher.loadContacts()
```

**ContactRecord.swift**
- Simple value types
- Hashable for Set operations
- PNG data for SwiftUI Image compatibility

### 2. Subscription System

**SubscriptionManager.swift**
- StoreKit 2 integration
- Daily spin counter with midnight reset
- Transaction verification
- Product loading and purchase flow

**Key Methods:**
```swift
// Check if user can spin
subscriptionManager.canSpin() -> Bool

// Record a spin (decrements counter)
subscriptionManager.recordSpin()

// Get remaining spins (3, 2, 1, or -1 for unlimited)
subscriptionManager.remainingFreeSpins() -> Int

// Purchase flow
try await subscriptionManager.purchase(product)
```

**Daily Reset Logic:**
- Checks if current day > last reset day
- Resets counter to 0 at midnight
- Uses `Calendar.current.startOfDay(for:)`

### 3. Notification System

**NotificationManager.swift**
- UserNotifications framework
- Daily repeating notification
- Time persistence with UserDefaults
- Authorization state tracking

**Key Methods:**
```swift
// Request permission
await notificationManager.requestAuthorization() -> Bool

// Schedule daily notification
notificationManager.scheduleNotification()

// Update time (auto-reschedules)
notificationManager.notificationTime = newTime
```

**Notification Flow:**
1. User completes first spin
2. Delay 0.5s after animation
3. Show alert prompt
4. If accepted, request authorization
5. Schedule daily notification
6. Store preference in UserDefaults

### 4. Analytics System

**ContactAnalytics.swift**
- Event tracking (spin, call, text)
- Streak calculation
- Monthly goals
- Achievement system
- Smart suggestions

**Event Types:**
```swift
enum ContactType {
    case call    // User tapped Call
    case text    // User tapped Text
    case spin    // Contact was shown
}
```

**Data Structures:**
```swift
ContactEvent: Codable {
    id: UUID
    contactId: String
    contactName: String
    type: ContactType
    timestamp: Date
}
```

### 5. UI Components (GlassKit)

**Glass Morphism Design System:**
- `LiquidGlassBackground()` - Animated gradient background
- `GlassCard { }` - Container with glass effect
- `.glass()` - Button modifier (subtle)
- `.glassProminent()` - Button modifier (bold)
- `GlassChip(text:)` - Small label chip
- `.centerColumnAdaptive()` - Responsive column width

**Responsive Design:**
- Uses `@Environment(\.horizontalSizeClass)`
- Adapts layouts with `ViewThatFits`
- Dynamic type support

## Data Persistence

### UserDefaults Keys

**Subscription System:**
- `dailySpinsCount` - Current day's spin count
- `lastResetDate` - Last midnight reset timestamp

**Contact Management:**
- `remainingContactIDs_v2` - Shuffled contact queue
- `excludedContactIDs_v1` - User-excluded contacts
- `seenContactIDs_v1` - "No repeats ever" history
- `noRepeatsEver_v1` - Toggle setting

**Notifications:**
- `dailyNotificationTime` - User's preferred time
- `hasShownFirstSpinPrompt` - One-time prompt flag

**Analytics:**
- `contactHistory_v1` - All contact events (JSON)
- `dailyStreaks_v1` - Streak counts per contact
- `monthlyGoals_v1` - Goal progression
- `achievements_v1` - Unlocked achievements

### Data Migration
- Version suffixes (`_v1`, `_v2`) allow schema changes
- Old data ignored if key changes
- No migration logic needed for V1

## Performance Considerations

### Contacts Loading
- **Heavy operation** on background thread
- Creates new CNContactStore per fetch (no Sendable issues)
- Filters out contacts without phone numbers
- Sorts phone numbers by preference

### Image Handling
- Prefers full-res, falls back to thumbnail
- Converts to PNG for SwiftUI compatibility
- Stored as Data in ContactRecord
- Displayed via `Image(uiImage: UIImage(data:))`

### Animation Performance
- Uses `.animation()` with specific values
- Haptic feedback on main thread
- Delays use `DispatchQueue.main.asyncAfter`
- Spring animations for natural feel

## Testing Tips

### Local Testing (No App Store Connect)

**Disable Subscription Checks:**
```swift
// In SubscriptionManager.swift
var isSubscribed = true  // Force premium mode
```

**Test Daily Reset:**
```swift
// In SubscriptionManager.swift - resetDailySpins()
// Change device date to tomorrow, then back
```

**Test Notifications:**
```swift
// Set time to 1 minute from now
notificationManager.notificationTime = Date().addingTimeInterval(60)
```

### Simulator Limitations
- Contacts need to be added manually
- Phone/SMS don't work (will show error)
- Notifications work but need device unlock
- Haptics don't work (no tactile feedback)

### Debug Helpers

**Print Contact Count:**
```swift
print("Loaded \(contacts.count) contacts")
print("Eligible: \(eligibleIDs().count)")
print("Remaining: \(remaining.count)")
```

**Check Subscription State:**
```swift
print("Subscribed: \(subscriptionManager.isSubscribed)")
print("Remaining spins: \(subscriptionManager.remainingFreeSpins())")
```

**Verify Notifications:**
```swift
UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
    print("Pending notifications: \(requests.count)")
    requests.forEach { print("  - \($0.identifier)") }
}
```

## Common Patterns

### Async/Await with MainActor
```swift
@MainActor
func bootstrap() async {
    isLoading = true
    defer { isLoading = false }

    // Heavy work off main thread
    let contacts = try await fetcher.loadContacts()

    // Update UI on main thread
    self.contacts = contacts
}
```

### Observable Pattern
```swift
@Observable
@MainActor
final class ViewModel {
    var state: String = ""  // Automatically triggers view updates

    func updateState() {
        state = "new value"  // View re-renders
    }
}
```

### Sheet Presentation
```swift
@State private var showSheet = false

Button("Open") { showSheet = true }
    .sheet(isPresented: $showSheet) {
        DetailView()
    }
```

### Alert Presentation
```swift
@State private var showAlert = false

Button("Show") { showAlert = true }
    .alert("Title", isPresented: $showAlert) {
        Button("OK") { }
        Button("Cancel", role: .cancel) { }
    } message: {
        Text("Message")
    }
```

## Customization Points

### Branding
- App name: "InTouch" (can be changed in multiple places)
- Colors: Defined in GlassKit.swift (teal/blue/purple gradient)
- Support email: `support@intouch.app` (in SettingsView)

### Limits
- Free spins: 3 per day (SubscriptionManager.swift:23)
- Monthly goal: 10 contacts (ContactAnalytics.swift:139)
- Top contacts limit: 5 (ContactAnalytics.swift:144)

### Pricing
- Monthly: $2.99 (App Store Connect)
- Yearly: $24.99 (App Store Connect)
- Product IDs in SubscriptionManager.swift

### Notification
- Default time: 7:00 PM (NotificationManager.swift:17)
- Message: "Time to reconnect!" (NotificationManager.swift:67)
- Body: "Spin to see who..." (NotificationManager.swift:68)

## Code Quality Notes

### Thread Safety
- All ViewModels marked `@MainActor`
- Heavy work moved to background queues
- UI updates always on main thread

### Error Handling
- Uses typed errors (`FetchError`)
- Shows user-friendly messages in UI
- Graceful degradation (no contacts → message)

### Accessibility
- Dynamic type support
- VoiceOver labels on buttons
- Sufficient color contrast (white on dark backgrounds)

### Memory Management
- No retain cycles (uses `[weak self]` where needed)
- Images stored as Data (not UIImage)
- Singletons for managers (intentional)

## Next Steps for Development

1. **Add StoreKit Configuration File**
   - Create `.storekit` file for local testing
   - Add product definitions matching App Store Connect

2. **Add History Tab**
   - Use ContactAnalytics data
   - Show timeline of past spins
   - Add action indicators

3. **Add App Icon**
   - Create icon set in Assets.xcassets
   - Use App Store requirements (1024x1024)

4. **Add Screenshots**
   - Main screen
   - Contact card
   - Analytics
   - Settings
   - For App Store submission

5. **Testing**
   - Unit tests for ViewModels
   - UI tests for critical flows
   - Subscription flow testing

---

**Last Updated:** January 2025
**iOS Version:** 18.5+
**Xcode Version:** 16.4+
