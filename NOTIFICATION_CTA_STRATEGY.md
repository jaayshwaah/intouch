# InTouch Notification CTA Strategy

## Overview
Our notifications use proven psychological triggers and urgency-based CTAs to maximize engagement. Each notification is designed to drive immediate action while maintaining a warm, friendly tone.

## Morning Notifications (7:00 AM)

### CTA Variations:
1. **"Who misses you?"** → "Spin now to find out who you should call today ☀️"
   - **Trigger**: Curiosity + FOMO
   - **Psychology**: Questions create open loops in the brain that demand closure

2. **"3 new spins unlocked!"** → "Someone's waiting to hear from you. Tap to spin 🎯"
   - **Trigger**: Novelty + Social obligation
   - **Psychology**: "Unlocked" suggests reward; "waiting" creates guilt/urgency

3. **"Make someone's day"** → "You have 3 spins. Who will you reconnect with? 💛"
   - **Trigger**: Altruism + Empowerment
   - **Psychology**: People want to feel like heroes; focuses on positive impact

4. **"Don't let them forget you"** → "Spin now before your spins expire at 4pm ⏰"
   - **Trigger**: Loss aversion + Deadline
   - **Psychology**: Fear of being forgotten + time-limited offer drives action

5. **"Reconnect in 30 seconds"** → "Tap to spin and strengthen a relationship today 🤝"
   - **Trigger**: Low barrier + Relationship value
   - **Psychology**: "30 seconds" removes friction; "strengthen" emphasizes benefit

## Afternoon Notifications (4:00 PM)

### CTA Variations:
1. **"Last chance today!"** → "3 fresh spins expire at midnight. Spin now 🌙"
   - **Trigger**: Scarcity + Deadline urgency
   - **Psychology**: Final opportunity creates immediate action impulse

2. **"Who did you forget to call?"** → "Your afternoon spins are ready. Make it count 📞"
   - **Trigger**: Guilt + Redemption opportunity
   - **Psychology**: Reminds of neglected relationships; offers easy fix

3. **"3 more chances"** → "Reconnect before the day ends. Tap to spin now ✨"
   - **Trigger**: Hope + Time pressure
   - **Psychology**: "Chances" implies opportunity; end-of-day creates urgency

4. **"Your evening spins arrived"** → "Someone needs to hear from you. Ready to spin? 💬"
   - **Trigger**: Delivery excitement + Social responsibility
   - **Psychology**: "Arrived" feels like receiving a gift; "needs" creates obligation

5. **"Turn 30 seconds into a memory"** → "Spin and surprise someone with a call tonight 🎉"
   - **Trigger**: Value proposition + Positive emotion
   - **Psychology**: Shows ROI on time; "surprise" adds excitement

## Key CTA Principles Used

### 1. Urgency & Scarcity
- "Expire at 4pm" / "Last chance" / "Before the day ends"
- Creates FOMO (Fear of Missing Out)
- Time-limited offers drive 2-3x higher engagement

### 2. Curiosity Gap
- "Who misses you?" / "Who did you forget to call?"
- Open-ended questions demand answers
- Brain seeks closure, drives tap-through

### 3. Low Friction
- "30 seconds" / "Tap to spin now"
- Removes perceived effort barrier
- Makes action feel easy and quick

### 4. Social Proof & Obligation
- "Someone's waiting" / "Someone needs to hear from you"
- Leverages social responsibility
- Guilt is powerful motivator for reconnection

### 5. Positive Framing
- "Make someone's day" / "Turn into a memory"
- Focus on benefits and positive outcomes
- More effective than negative framing

### 6. Reward Language
- "Unlocked" / "Arrived" / "Fresh spins"
- Treats spins as valuable resources
- Creates dopamine anticipation

### 7. Action Verbs
- "Spin now" / "Tap to spin" / "Reconnect"
- Direct, clear instructions
- Reduces decision fatigue

## A/B Testing Recommendations

### Metrics to Track:
1. **Notification Open Rate** (target: >25%)
2. **Tap-through Rate** (target: >15%)
3. **Spin within 5 min** (target: >10%)
4. **Daily Active Users** change
5. **Retention Day 7** impact

### Testing Strategy:
- **Week 1-2**: Baseline with current CTAs
- **Week 3-4**: Test urgency-heavy vs. emotion-heavy
- **Week 5-6**: Test question vs. statement formats
- **Week 7+**: Personalize based on user behavior

### Advanced Personalization (Future):
```swift
// Customize based on user patterns
if user.lastSpinTime > 3.days {
    title = "We miss you!"
    body = "Your friends do too. Come spin now 💛"
} else if user.streakDays >= 7 {
    title = "🔥 \(user.streakDays) day streak!"
    body = "Keep it going! Spin to maintain your streak"
} else if user.morningSpinner {
    title = "Your daily ritual awaits"
    body = "Morning spin time. Who's today's lucky contact? ☕"
}
```

## Emoji Strategy

### Morning (7am): Fresh, energetic
- ☀️ Sunrise (new beginning)
- 🎯 Target (focused action)
- 💛 Yellow heart (warmth)
- ⏰ Clock (time urgency)
- 🤝 Handshake (connection)

### Afternoon (4pm): Evening-focused, closing
- 🌙 Moon (end of day approaching)
- 📞 Phone (direct action)
- ✨ Sparkles (special moment)
- 💬 Chat (conversation)
- 🎉 Party (celebration)

## Notification Fatigue Prevention

### Best Practices:
1. **Only 2 notifications/day** (7am, 4pm)
2. **Rotate CTAs** to maintain novelty
3. **Smart silence**: Don't notify if user just used app
4. **Preference center**: Let users customize times
5. **Adaptive timing**: Learn user's peak engagement hours

### When to Back Off:
- User disabled notifications → respect choice
- User premium subscriber → reduce frequency
- User spins regularly without prompts → less aggressive
- Consecutive ignored notifications → pause for 2 days

## Conversion-Focused Notifications (Future)

### Out of Spins (Paywall trigger):
- **Title**: "You're on fire! 🔥"
- **Body**: "Used all 6 spins today. Unlock unlimited for $2.99/mo"
- **Category**: PREMIUM_UPSELL

### Streak Risk:
- **Title**: "Don't break your 12-day streak!"
- **Body**: "You have 2 hours left. Spin now to keep it alive 💪"
- **Category**: STREAK_REMINDER

### Re-engagement (Lapsed users):
- **Title**: "Your friends haven't heard from you"
- **Body**: "Come back? We've saved your 3-day streak for you 💛"
- **Category**: WIN_BACK

## Performance Benchmarks

### Industry Standards:
- Push notification opt-in: 40-50%
- Open rate: 10-15%
- Tap-through: 5-8%

### InTouch Targets:
- **Opt-in**: 60%+ (social app)
- **Open rate**: 25%+ (high-value action)
- **Tap-through**: 15%+ (urgency + scarcity)
- **Spin within 5min**: 10%+ (immediate action)

### Red Flags:
- Open rate <10% → CTA not compelling
- Declining over time → notification fatigue
- Disable rate >5%/week → too frequent or annoying

## Legal & Best Practices

### Apple Guidelines:
✅ Clear value proposition
✅ User can disable anytime
✅ Respect system settings
✅ Don't send promotional ads
✅ Time appropriately (not late night)

### Privacy:
✅ No personal data in notifications
✅ Generic enough to not embarrass user
✅ No contact names in lock screen notifications

## Implementation Notes

- **Random selection**: Each notification randomly picks from array
- **No storage needed**: Pure function, picks on schedule
- **A/B test ready**: Easy to add weighting to variations
- **Localization ready**: Structure supports multiple languages
