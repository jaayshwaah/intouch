# Testing Mode - Unlimited Spins Enabled

## 🧪 Current Status: TESTING MODE ON

**Everyone has unlimited spins for testing purposes.**

## ✅ What's Changed

### 1. SubscriptionManager.swift
- `canSpin()` always returns `true`
- `remainingFreeSpins()` returns `-1` (unlimited)
- Original code is commented out

### 2. RandomContactView.swift
- Spin counter badge is hidden
- "Upgrade" button is hidden
- Original code is commented out

## 🔄 How to Restore Limits for Production

### Step 1: Restore SubscriptionManager
**File**: [SubscriptionManager.swift](InTouch/SubscriptionManager.swift)

**Lines 94-116** - Uncomment the original `canSpin()` code:
```swift
func canSpin() -> Bool {
    // TESTING: Unlimited spins for everyone
    return true  // DELETE THIS LINE

    /* Original code - restore when testing is complete
    // UNCOMMENT THIS ENTIRE BLOCK ↓
```

**Lines 125-135** - Uncomment the original `remainingFreeSpins()` code:
```swift
func remainingFreeSpins() -> Int {
    // TESTING: Show unlimited
    return -1  // DELETE THIS LINE

    /* Original code - restore when testing is complete
    // UNCOMMENT THIS ENTIRE BLOCK ↓
```

### Step 2: Restore Spin Counter UI
**File**: [RandomContactView.swift](InTouch/RandomContactView.swift)

**Lines 117-155** - Uncomment the spin counter UI:
```swift
// TESTING: Hide spin counter
// Uncomment when ready to show limits again
/*  // DELETE THIS LINE AND THE CLOSING */

// The entire spin counter block
```

## 📋 Quick Checklist for Production

Before shipping to App Store:

- [ ] Uncomment `canSpin()` in SubscriptionManager.swift
- [ ] Uncomment `remainingFreeSpins()` in SubscriptionManager.swift
- [ ] Uncomment spin counter UI in RandomContactView.swift
- [ ] Delete this TESTING_MODE.md file
- [ ] Test that free users see "3 spins remaining"
- [ ] Test that paywall appears after 3 spins
- [ ] Test that counter resets at midnight

## 🎯 What Production Will Look Like

### Free Users (3 spins/day)
```
┌─────────────────────────┐
│       InTouch           │
│  ○ 3 spins remaining    │  ← Shows under title
│                         │
│   [Contact Card]        │
│                         │
└─────────────────────────┘
```

After 3 spins:
```
┌─────────────────────────┐
│       InTouch           │
│  👑 Upgrade for         │  ← Orange button
│     unlimited spins     │
└─────────────────────────┘
```

### Premium Users (Unlimited)
```
┌─────────────────────────┐
│       InTouch           │
│   (no counter shown)    │  ← Nothing displayed
│                         │
│   [Contact Card]        │
│                         │
└─────────────────────────┘
```

## 🔧 Current Limits (When Restored)

- **Free Tier**: 3 spins per day
- **Premium**: Unlimited spins
- **Reset Time**: Midnight (local time)
- **Product IDs**:
  - Monthly: `com.joshking.InTouch.premium.monthly` ($2.99)
  - Yearly: `com.joshking.InTouch.premium.yearly` ($24.99)

## 💡 Why Testing Mode?

Testing mode allows you to:
- ✅ Test the spin animation repeatedly
- ✅ Test contact selection logic
- ✅ Test UI without hitting limits
- ✅ Demo the app to others
- ✅ Debug issues without waiting for midnight

---

**Mode**: TESTING (Unlimited Spins)
**When to Restore**: Before App Store submission
**Files Modified**: 2 (SubscriptionManager.swift, RandomContactView.swift)
