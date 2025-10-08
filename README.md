# InTouch - iOS Contact Spinner App

Stay connected with the people who matter. InTouch helps you maintain relationships by randomly selecting a contact daily, making it easy and fun to reach out.

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-iOS%2018.5%2B-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)

## ✨ Features

### Core Experience
- 🎲 **Daily Contact Spinner** - Beautiful animation with haptic feedback
- 📱 **Quick Actions** - Instantly call or text your selected contact
- 🎨 **Stunning UI** - Liquid glass morphism design with dynamic backgrounds
- 🔔 **Daily Reminders** - Optional notifications to stay consistent
- 📊 **Analytics Dashboard** - Track your connection streaks and patterns
- 🎯 **Smart Suggestions** - Get reminded about contacts you haven't reached in a while

### Free Tier
- ✅ 3 spins per day (resets at midnight)
- ✅ Call & text integration
- ✅ Contact management & exclusions
- ✅ Daily notification
- ✅ Full analytics access

### Premium Tier ($2.99/mo or $24.99/yr)
- ⭐ **Unlimited spins** - Spin as many times as you want
- 🔮 Future: Multiple daily reminders
- 🔮 Future: Custom contact lists (work, family, etc.)

## 🚀 Current Status

**All V1 features are COMPLETE and ready to test!**

### What Works Right Now:
1. ✅ Main spin screen with beautiful animations
2. ✅ Contacts integration with permission handling
3. ✅ Call/Text system integrations
4. ✅ Free tier with 3 daily spins
5. ✅ Premium subscription with StoreKit 2
6. ✅ Daily notifications at custom times
7. ✅ Settings screen with all preferences
8. ✅ Contact analytics and streaks
9. ✅ Smart suggestions
10. ✅ Contact exclusion management
11. ✅ First-time notification prompt after first spin

## 🛠️ Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **Contacts Framework** - Native iOS contacts integration
- **StoreKit 2** - In-app purchases and subscriptions
- **UserNotifications** - Daily reminder system
- **Core Haptics** - Satisfying tactile feedback
- **UserDefaults** - Local data persistence
- **Observation Framework** - Modern state management

## 📁 Project Structure

```
InTouch/
├── Core App
│   ├── InTouchApp.swift              # App entry + notifications
│   ├── RandomContactView.swift       # Main spin screen
│   └── RandomContactViewModel.swift  # Business logic
│
├── Contact Management
│   ├── ContactFetcher.swift          # Contacts framework wrapper
│   ├── ContactRecord.swift           # Data models
│   ├── ContactAvatarView.swift       # Avatar UI component
│   └── ManageExclusionsView.swift    # Exclusion settings
│
├── Monetization
│   ├── SubscriptionManager.swift     # StoreKit + usage limits
│   └── PaywallView.swift            # Premium upgrade screen
│
├── Notifications
│   └── NotificationManager.swift     # Daily reminder scheduling
│
├── Settings & Analytics
│   ├── SettingsView.swift           # Settings & preferences
│   ├── ContactAnalytics.swift       # Tracking & achievements
│   └── AnalyticsView.swift          # Stats dashboard
│
├── UI Components
│   ├── GlassKit.swift               # Glass morphism components
│   └── MessageCompose.swift         # SMS composer wrapper
│
└── Documentation
    ├── README.md                     # This file
    └── SETUP.md                      # Setup instructions
```

## 🎯 Quick Start

### 1. Open the Project
```bash
cd /Users/joshking/InTouch
open InTouch.xcodeproj
```

### 2. Run in Xcode
- Select your development team in project settings
- Choose iPhone simulator or device (iOS 18.5+)
- Press **Cmd + R** to build and run

### 3. Test the Flow
1. App launches → Tap "Spin" button
2. Grant Contacts permission when prompted
3. See a random contact appear with animation
4. Try "Call" or "Text" buttons
5. After first spin, you'll see notification prompt
6. Enable notifications to get daily reminders

### 4. Test Free Tier Limits
- You get 3 free spins
- After 3, you'll see the upgrade prompt
- Counter resets at midnight

## ⚙️ Configuration

### In-App Purchase Setup

Before releasing to production, configure in App Store Connect:

1. **Monthly Subscription**
   - Product ID: `com.joshking.InTouch.premium.monthly`
   - Price: $2.99/month

2. **Yearly Subscription**
   - Product ID: `com.joshking.InTouch.premium.yearly`
   - Price: $24.99/year

**To change product IDs:** Edit `SubscriptionManager.swift` lines 13-14

### Notification Configuration

Already configured! Notifications:
- Request permission after first spin
- Default time: 7:00 PM
- Customizable in Settings
- Message: "Time to reconnect! Spin to see who you should reach out to today 🎲"

## 🧪 Testing Checklist

- [ ] App launches without crashes
- [ ] Contacts permission prompt appears
- [ ] Spin animation works smoothly
- [ ] Contact appears with photo and phone
- [ ] Call button opens phone dialer
- [ ] Text button opens Messages
- [ ] Spin counter decrements (3 → 2 → 1 → 0)
- [ ] Paywall appears after 3rd spin
- [ ] Notification prompt appears after first spin
- [ ] Settings screen opens and works
- [ ] Analytics screen shows data
- [ ] Contact exclusions work
- [ ] "No repeats ever" mode works
- [ ] Daily notification fires at set time

## 📋 Known Limitations

### V1 Scope
- No history tab yet (data is tracked, UI not built)
- Premium features are placeholder (unlimited spins works)
- Subscriptions need App Store Connect setup to test
- No widgets yet

### Testing Notes
- Use sandbox tester account for subscriptions
- Notifications won't show in simulator preview
- Contacts need to be added to simulator/device for testing

## 🔮 Roadmap (V2)

1. **History Tab**
   - Timeline view of past spins
   - Visual streak indicators
   - Action tracking (called/texted)

2. **Enhanced Premium Features**
   - Multiple daily reminder times
   - Custom contact lists (work, family, friends)
   - Priority contacts

3. **Widgets**
   - Home screen widget with today's contact
   - Lock screen widget with quick actions

4. **Integrations**
   - WhatsApp support
   - Email support
   - Calendar event creation

## 🐛 Troubleshooting

### Build Issues
- Ensure Xcode 16.4+ is installed
- Development team is selected in project settings
- iOS deployment target is 18.5

### Runtime Issues

**Contacts not loading:**
- Check Settings > InTouch > Contacts permission
- Ensure device/simulator has contacts with phone numbers

**Notifications not working:**
- Check Settings > InTouch > Notifications permission
- Test with time set 1 minute ahead
- Disable Do Not Disturb mode

**Subscription testing:**
- Add StoreKit configuration file
- Use sandbox tester account from App Store Connect
- Product IDs must match exactly

## 📝 License

Copyright © 2025 Josh King. All rights reserved.

---

**Ready to build?** See [SETUP.md](SETUP.md) for detailed setup instructions.

**Questions?** Contact support@intouch.app
