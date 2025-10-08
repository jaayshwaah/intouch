# InTouch - Setup Instructions

## App Overview
InTouch is an iOS contact spinner app that helps people stay connected by randomly selecting a contact daily. The app features a beautiful glass morphism UI, contact analytics, and premium subscription options.

## What's Already Built ✅

### Core Features (V1 - Complete!)
1. **Main Spin Screen**
   - Beautiful liquid glass background with animations
   - Large spin button with satisfying haptic feedback
   - Contact card with photo, name, and phone numbers
   - Quick action buttons: Call, Text, Spin Again
   - Spin counter showing remaining free spins

2. **Contacts Integration**
   - Permission handling (requests on first use)
   - Fetches all contacts with phone numbers
   - Smart phone number sorting (mobile preferred)
   - Contact photo display with avatars

3. **Free vs Premium Tiers**
   - Free: 3 spins per day (resets at midnight)
   - Premium: Unlimited spins
   - Daily spin counter with visual feedback
   - Paywall integration

4. **Daily Notifications**
   - Optional daily reminder at user-chosen time (default 7pm)
   - First-time prompt after first spin
   - Settings to enable/disable and change time
   - Notification text: "Time to reconnect! Spin to see who you should reach out to today 🎲"

5. **Settings Screen**
   - Notification time picker
   - Contact preferences (no repeats ever mode)
   - Manage exclusions (hide specific contacts)
   - Clear seen history
   - Premium upgrade button
   - Subscription management

6. **Analytics Dashboard**
   - Contact history tracking
   - Daily streaks
   - Monthly goals
   - Smart suggestions (long time no see, maintain streak, etc.)
   - Achievements system

7. **Contact Management**
   - Exclude contacts from spins
   - "No repeats ever" mode
   - Spin history persistence

## Setup Steps

### 1. App Store Connect Configuration

#### A. Create App Record
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app with Bundle ID: `com.joshking.InTouch`
3. Fill in app information, screenshots, etc.

#### B. Configure In-App Purchases
You need to create two auto-renewable subscriptions:

1. **Monthly Premium**
   - Product ID: `com.joshking.InTouch.premium.monthly`
   - Price: $2.99/month
   - Display Name: "Premium Monthly"
   - Description: "Unlimited spins and daily reminders"

2. **Yearly Premium**
   - Product ID: `com.joshking.InTouch.premium.yearly`
   - Price: $24.99/year
   - Display Name: "Premium Yearly"
   - Description: "Unlimited spins and daily reminders - Save 30%!"

**IMPORTANT:** If you want to use different product IDs, update them in:
- `InTouch/SubscriptionManager.swift` (lines 13-14)

### 2. Testing on Device/Simulator

#### Running the App
1. Open `InTouch.xcodeproj` in Xcode
2. Select your development team in project settings
3. Select a device/simulator (iOS 18.5+)
4. Press Cmd+R to build and run

#### First Launch Flow
1. App opens → Shows "Ready to reconnect?" message
2. Tap "Spin" button
3. Contacts permission prompt appears
4. Grant permission
5. Contact appears with haptic feedback
6. After first spin, notification prompt appears
7. Enable notifications (optional)

#### Testing Free Tier Limits
- You get 3 free spins per day
- After 3 spins, "Upgrade for unlimited spins" button appears
- Counter resets at midnight

#### Testing Notifications
1. Go to Settings screen (gear icon)
2. Enable notifications if not already
3. Set notification time to 1 minute from now
4. Lock device/background app
5. Wait for notification to appear

### 3. Required Capabilities

Already configured in Info.plist:
- ✅ Contacts access (`NSContactsUsageDescription`)
- ✅ Notification support (configured in code)

### 4. Building for Release

#### Before Submitting to App Store
1. **Update Product IDs** (if different from default)
   - See `SubscriptionManager.swift`

2. **Configure StoreKit Configuration File** (for testing)
   - Add `.storekit` file for testing subscriptions locally
   - Configure products to match App Store Connect

3. **Update Version/Build Numbers**
   - In Xcode project settings
   - Current: Version 1.0, Build 1

4. **Add App Icon**
   - Add icon set in Assets.xcassets

5. **Test Subscription Flow**
   - Use sandbox tester account
   - Test both monthly and yearly purchases
   - Test restore purchases

## File Structure

```
InTouch/
├── InTouchApp.swift              # App entry point + notification delegate
├── RandomContactView.swift       # Main spin screen
├── RandomContactViewModel.swift  # Main view logic
├── ContactFetcher.swift          # Contacts framework integration
├── ContactRecord.swift           # Contact data models
├── ContactAvatarView.swift       # Avatar display component
├── SubscriptionManager.swift     # StoreKit 2 + usage tracking
├── PaywallView.swift            # Premium upgrade screen
├── NotificationManager.swift     # Daily notification scheduling
├── SettingsView.swift           # Settings and preferences
├── ManageExclusionsView.swift   # Contact exclusion management
├── ContactAnalytics.swift       # History, streaks, achievements
├── AnalyticsView.swift          # Analytics dashboard
├── MessageCompose.swift         # SMS composition
├── GlassKit.swift              # Glass morphism UI components
└── SETUP.md                    # This file
```

## Pricing Strategy

### Free Tier
- 3 spins per day
- Basic contact management
- All core features accessible

**Why 3 spins?**
- Enough to skip 2 unwanted contacts and still connect with 1 person
- Creates value perception without being frustrating
- Low enough to encourage premium upgrade for power users

### Premium Tier
- **Monthly**: $2.99/month
- **Yearly**: $24.99/year (30% savings)

**Premium Benefits:**
- Unlimited daily spins
- Future: Multiple daily reminders
- Future: Custom contact lists

## Next Steps (V2 Features)

These features are mentioned in the UI but not yet implemented:

1. **Multiple Daily Reminders** (Premium)
   - Let premium users set multiple notification times
   - Different reminder messages throughout the day

2. **Custom Contact Lists** (Premium)
   - Work contacts only
   - Family only
   - Close friends
   - etc.

3. **History Tab**
   - Visual timeline of past spins
   - Mark actions taken (called/texted)
   - Streak visualization

4. **Widgets**
   - Home screen widget showing today's contact
   - Lock screen widget with quick action

5. **Share Feature**
   - Share contact details to other apps
   - Email/WhatsApp integration

## Troubleshooting

### Contacts Not Loading
- Check Contacts permission in Settings > InTouch
- Ensure device has contacts with phone numbers
- Check console for error messages

### Notifications Not Working
- Check notification permission in Settings > InTouch
- Verify notification time is set correctly
- Test with time set to 1 minute ahead
- Check that device is not in Do Not Disturb mode

### Subscription Not Working
- Ensure product IDs match App Store Connect exactly
- Add StoreKit configuration file for local testing
- Use sandbox tester account
- Check App Store Connect for subscription setup

### Daily Spin Limit Not Resetting
- Check device date/time settings
- Spin counter resets at midnight local time
- UserDefaults key: "dailySpinsCount" and "lastResetDate"

## Support

For issues or questions:
- Email: support@intouch.app (update this in SettingsView.swift)
- GitHub: [Your repo URL]

---

Built with ❤️ using SwiftUI and StoreKit 2
