# InTouch Localization Setup

## Overview
I've created a `Localizable.xcstrings` file with all the key strings from the InTouch app. This file makes it easy to add support for multiple languages.

## What's Included

The `.xcstrings` file contains:
- ✅ Main screen text (empty state, spin button, loading)
- ✅ Contact card actions (call, message, exclude)
- ✅ Settings screen labels
- ✅ Paywall/premium content
- ✅ Analytics labels
- ✅ Notification messages (all morning/afternoon CTAs)
- ✅ Common buttons (Done, Cancel, OK)
- ✅ Error messages
- ✅ Plural support (e.g., "1 spin left" vs "2 spins left")

## Next Steps in Xcode

### 1. Add Localizable.xcstrings to Xcode Project
1. Open `InTouch.xcodeproj` in Xcode
2. Right-click on the `InTouch` folder in Project Navigator
3. Select "Add Files to InTouch..."
4. Navigate to and select `Localizable.xcstrings`
5. Make sure "Copy items if needed" is checked
6. Click "Add"

### 2. Enable Localization in Project Settings
1. Select the project (blue icon) in Project Navigator
2. Select the "InTouch" target
3. Go to "Info" tab
4. Under "Localizations", click "+"
5. Add languages you want to support:
   - Spanish (es)
   - French (fr)
   - German (de)
   - Japanese (ja)
   - etc.

### 3. Verify String Catalog
1. Click on `Localizable.xcstrings` in Project Navigator
2. You should see the String Catalog editor
3. All strings should show "English" with green checkmarks
4. To add translations, simply type in the translation fields

## How to Use in Code

### Current Usage (Hardcoded):
```swift
Text("Ready to reconnect?")
```

### Updated Usage (Localized):
```swift
Text("main.empty.title", bundle: .main)
// or using String(localized:)
Text(String(localized: "main.empty.title"))
```

## String Keys Reference

### Main Screen
- `main.title` - "InTouch"
- `main.empty.title` - "Ready to reconnect?"
- `main.spin.button` - "Spin the Wheel"
- `main.loading.text` - "Picking someone special..."
- `main.spins.remaining` - "%lld spin(s) left" (plural support)
- `main.spins.out` - "Out of spins"
- `main.upgrade.button` - "Get Unlimited"

### Contact Card
- `contact.call.button` - "Call"
- `contact.message.button` - "Message"
- `contact.exclude.button` - "Exclude Contact"
- `contact.conversation.title` - "Conversation Starter"

### Settings
- `settings.title` - "Settings"
- `settings.notifications.title` - "Daily Reminders"
- `settings.privacy.button` - "Privacy Policy"
- `settings.support.button` - "Contact Support"

### Paywall
- `paywall.title` - "Unlock Premium"
- `paywall.subtitle` - "Stay connected with unlimited spins..."
- `paywall.purchase.button` - "Start Free Trial"
- `paywall.restore.button` - "Restore Purchases"

### Notifications (All 10 CTA variations included)
- `notification.morning.title1` - "Who misses you?"
- `notification.morning.body1` - "Spin now to find out..."
- `notification.afternoon.title1` - "Last chance today!"
- etc.

### Common
- `common.done` - "Done"
- `common.cancel` - "Cancel"
- `common.ok` - "OK"

### Errors
- `error.no.contacts` - "No contacts available"
- `error.permission.denied` - "Please enable contacts access..."

## Adding New Languages

### Option 1: Using Xcode (Recommended)
1. Click `Localizable.xcstrings` in Project Navigator
2. Click "+" in the bottom left
3. Select language
4. Fill in translations in the editor

### Option 2: Manual Editing
The `.xcstrings` file is JSON, so you can add translations directly:

```json
"main.title" : {
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "InTouch"
      }
    },
    "es" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "EnContacto"
      }
    },
    "fr" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "EnContact"
      }
    }
  }
}
```

## Translation Services

### Recommended Translation Services:
1. **Human Translation**:
   - Professional: Rev.com, Gengo.com
   - Community: Lokalise, Crowdin

2. **Machine Translation** (for initial draft):
   - DeepL (best quality)
   - Google Translate
   - Apple Translation API

3. **Translation Management Platforms**:
   - Lokalise (integrates with Xcode)
   - Phrase
   - POEditor

## Testing Localization

### Test in Simulator:
1. Run app in Simulator
2. Settings → General → Language & Region
3. Change "iPhone Language" to test language
4. Restart app

### Test with Scheme:
1. Edit Scheme (Product → Scheme → Edit Scheme)
2. Go to "Run" → "Options"
3. Under "App Language", select language
4. Run app

### Test Plurals:
```swift
// English: "1 spin left" vs "2 spins left"
// Spanish: "1 giro restante" vs "2 giros restantes"
let remaining = 2
Text(String(localized: "main.spins.remaining", defaultValue: "\(remaining) spin(s) left"))
```

## App Store Localization

Once you've translated the app strings, you should also localize:

### App Store Metadata:
- App name (optional, keep "InTouch" globally)
- Subtitle
- Description
- Keywords
- Screenshots (with localized text overlays)
- What's New notes

### Languages Priority (based on iOS market share):
1. **English** (base) - 36%
2. **Chinese (Simplified)** - 19%
3. **Spanish** - 8%
4. **Japanese** - 6%
5. **German** - 4%
6. **French** - 3%
7. **Portuguese** - 3%
8. **Russian** - 3%
9. **Italian** - 2%
10. **Korean** - 2%

### ROI by Language:
- Top 3 (EN, ZH, ES) cover 63% of iOS users
- Top 5 add 10% more coverage
- Spanish is critical for US market (Latino population)

## Current Status

✅ **Created**: `Localizable.xcstrings` with 50+ strings
✅ **Included**: All UI text, notifications, errors
✅ **Plural Support**: Enabled for countable items
✅ **Ready**: Just needs to be added to Xcode project

❌ **Not Yet Done**:
- Adding file to Xcode project (manual step required)
- Updating code to use localized strings
- Adding additional language translations

## Benefits of Localization

1. **Market Expansion**: Access 64% non-English iOS users
2. **App Store Rankings**: Better rankings in local stores
3. **User Trust**: Local language = professional app
4. **Conversion**: 3x higher conversion for localized apps
5. **Reviews**: Users more likely to rate/review in their language
6. **Support**: Fewer support tickets from confused users

## Notes

- The `.xcstrings` format is Xcode 15+ only
- For Xcode 14 and below, you'd need `.strings` files instead
- All strings are marked as "manual" extraction to avoid auto-generation
- Emojis work across all languages (no translation needed)
- Right-to-left (RTL) languages like Arabic need additional testing
