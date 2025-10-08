# InTouch Pricing & Spin System

## Free Tier - 6 Spins Per Day

### Spin Allocation
- **Morning**: 3 spins available at 7:00 AM
- **Afternoon**: 3 spins available at 4:00 PM (16:00)
- **No rollover**: Unused spins do not carry over to the next period
- **Maximum**: 3 spins at any given time

### Spin Reset Logic
The app automatically resets spins when entering a new time period:
- **Morning Period**: 7:00 AM - 3:59 PM
- **Afternoon Period**: 4:00 PM - 6:59 AM (next day)

### Notifications
Users receive notifications when spins are refilled:
- **7:00 AM**: "3 fresh spins! Your morning spins are ready. Reach out to someone today 🌅"
- **4:00 PM**: "3 more spins! Your afternoon spins are ready. Time to reconnect ☀️"

## Premium Tier - Unlimited Spins

### Pricing (Configure in App Store Connect)
- **Monthly**: $2.99 USD/month
- **Yearly**: $24.99 USD/year (Save 30%)

### Premium Features
- Unlimited spins (no time restrictions)
- Advanced analytics
- No ads
- Priority support

## App Store Connect Configuration

### Product IDs
When setting up in-app purchases in App Store Connect, use these exact product IDs:

1. **Monthly Subscription**
   - Product ID: `com.joshking.InTouch.premium.monthly`
   - Price: $2.99 USD
   - Billing cycle: 1 month
   - Auto-renewable: Yes

2. **Yearly Subscription**
   - Product ID: `com.joshking.InTouch.premium.yearly`
   - Price: $24.99 USD
   - Billing cycle: 1 year
   - Auto-renewable: Yes

### Subscription Group
- Group name: InTouch Premium
- Both products should be in the same subscription group
- Yearly should be marked as a better value

## Implementation Files

### Code Files
- `SubscriptionManager.swift`: Handles spin tracking, limits, and subscription state
- `NotificationManager.swift`: Schedules 7am and 4pm notifications
- `PaywallView.swift`: Premium subscription purchase screen
- `RandomContactView.swift`: Main UI showing remaining spins

### Key Functions
- `canSpin()`: Checks if user can perform a spin
- `recordSpin()`: Increments spin count for free users
- `remainingFreeSpins()`: Returns number of spins left in current period
- `nextRefillTime()`: Returns when next spin refill occurs
- `checkAndResetSpins()`: Automatically resets spins at 7am and 4pm

## Testing

### To Test Spin System
1. Change device time to 6:59 AM → should have 0 spins (or previous period's remaining)
2. Change device time to 7:00 AM → should reset to 3 spins
3. Use all 3 spins → should show 0 spins
4. Change device time to 3:59 PM → should still show 0 spins
5. Change device time to 4:00 PM → should reset to 3 spins

### To Test Notifications
1. Enable notifications in Settings
2. Schedule notifications via NotificationManager
3. Check notification center for pending notifications:
   - Morning notification at 7:00 AM
   - Afternoon notification at 4:00 PM

### To Test Subscriptions
1. Use Sandbox testers in App Store Connect
2. Create test accounts
3. Test purchase flow
4. Verify unlimited spins after subscription
5. Test restore purchases
6. Test subscription expiration

## Analytics Tracking

The app currently tracks:
- Total spins performed
- Current streak (days in a row)
- Contacts reached out to
- Spin history with timestamps

### Recommended Analytics to Add
- Spin usage by time period (morning vs afternoon)
- Peak usage hours
- Conversion rate (free to premium)
- Average spins per user per day
- Notification engagement rate
- Spin-to-contact rate (did they actually reach out?)

Use Apple App Analytics or integrate Firebase/Mixpanel for detailed tracking.
