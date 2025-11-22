# InTouch - App Store Submission Checklist

## ✅ Completed (By Claude Code)

- [x] **Lower iOS deployment target** from 18.5 to 16.0
- [x] **Create PrivacyInfo.xcprivacy** manifest file
- [x] **Deploy landing page** with privacy policy, terms, and support
- [x] **Update privacy policy URL** in app settings
- [x] **Remove testing comments** from production code
- [x] **Create StoreKit configuration** for local IAP testing
- [x] **Draft App Store metadata** (description, keywords, What's New)

---

## 🔲 Required Before Submission

### 1. Website Setup (Optional but Recommended)

- [ ] **Enable GitHub Pages**
  - Go to: https://github.com/jaayshwaah/intouch/settings/pages
  - Under "Build and deployment", select "Deploy from a branch"
  - Select branch: `main`, folder: `/docs`
  - Click Save
  - Your site will be live at: https://jaayshwaah.github.io/intouch/

- [ ] **OR Set up Vercel** (as you mentioned)
  - Connect your GitHub repo to Vercel
  - Point Vercel to build from the `/docs` folder
  - Connect your custom domain
  - **Important:** Update SettingsView.swift with your custom domain URL if different from GitHub Pages

### 2. App Store Connect Setup

- [ ] **Create App Store Connect account** (if not already done)
  - Go to: https://appstoreconnect.apple.com
  - Enroll in Apple Developer Program ($99/year) if needed

- [ ] **Create new app listing**
  - Click "My Apps" → "+" → "New App"
  - Platform: iOS
  - Name: InTouch
  - Primary Language: English (US)
  - Bundle ID: com.joshking.InTouch
  - SKU: INTOUCH-001 (or your preference)

- [ ] **Configure App Information**
  - Name: InTouch
  - Subtitle: Stay connected with loved ones
  - Privacy Policy URL: https://jaayshwaah.github.io/intouch/privacy (or your custom domain)
  - Category: Primary: Social Networking, Secondary: Lifestyle
  - Content Rights: No, I do not hold exclusive rights

- [ ] **Set up App Privacy**
  - Data Types Collected: None
  - Confirm no data tracking
  - Confirm no data linked to user

### 3. In-App Purchases Configuration

- [ ] **Create Subscription Group**
  - Name: InTouch Premium
  - Reference Name: InTouch Premium Subscriptions

- [ ] **Create Monthly Subscription**
  - Product ID: com.joshking.InTouch.premium.monthly
  - Reference Name: InTouch Premium Monthly
  - Subscription Duration: 1 Month
  - Price: $2.99 (Tier 10)
  - Subscription Group: InTouch Premium
  - Display Name: Premium Monthly
  - Description: Unlimited contact spins every day

- [ ] **Create Yearly Subscription**
  - Product ID: com.joshking.InTouch.premium.yearly
  - Reference Name: InTouch Premium Yearly
  - Subscription Duration: 1 Year
  - Price: $19.99 (Tier 25)
  - Subscription Group: InTouch Premium
  - Display Name: Premium Yearly
  - Description: Unlimited contact spins every day - Save 44%!

- [ ] **Submit IAPs for review** (can be done before app submission)

### 4. Test In-App Purchases

- [ ] **Create Sandbox Tester Account**
  - In App Store Connect: Users and Access → Sandbox Testers
  - Create a new sandbox tester with a unique email

- [ ] **Test on Device**
  - Build app to physical device
  - Sign out of real App Store account in Settings
  - Test monthly subscription purchase
  - Test yearly subscription purchase
  - Test restore purchases
  - Verify subscription status displays correctly

- [ ] **Verify StoreKit Configuration**
  - Test in Xcode simulator using Configuration.storekit
  - Confirm both products load correctly
  - Test purchase flow works

### 5. Screenshots Preparation

You mentioned you have screenshots! You need to prepare them for these sizes:

- [ ] **iPhone 6.7" Display** (1290 x 2796 px)
  - 3-10 screenshots showing key features
  - Main screen, contact selected, streak, settings, premium

- [ ] **iPhone 6.5" Display** (1242 x 2688 px)
  - Same screenshots as above, resized

- [ ] **iPad Pro 12.9"** (2048 x 2732 px)
  - 3-10 screenshots optimized for iPad layout

**Tools for screenshot prep:**
- Xcode Simulator (capture at correct sizes)
- [Shotbot](https://shotbot.io/) - Free screenshot framing tool
- [App Store Screenshot](https://www.appstorescreenshot.com/) - Online generator
- Figma or Sketch for custom design

### 6. App Icon Verification

- [ ] **Verify app icon is correct**
  - 1024x1024 PNG (already exists)
  - No alpha channel
  - No rounded corners (iOS adds them)
  - Located: `InTouch/Assets.xcassets/AppIcon.appiconset/`

### 7. Build and Archive

- [ ] **Update version numbers if needed**
  - Marketing Version: 1.0 (already set)
  - Build Number: 1 (already set)

- [ ] **Clean build folder**
  - In Xcode: Product → Clean Build Folder (Cmd+Shift+K)

- [ ] **Archive the app**
  - Select "Any iOS Device" as destination
  - Product → Archive (Cmd+B to build first)
  - Wait for archive to complete

- [ ] **Validate Archive**
  - In Organizer → Archives
  - Select your archive → Distribute App → App Store Connect
  - Click "Validate"
  - Fix any validation errors

- [ ] **Upload to App Store Connect**
  - After validation passes, click "Distribute"
  - Wait for processing (can take 30-60 minutes)

### 8. App Store Connect - Version Information

- [ ] **Upload screenshots**
  - Add screenshots for each required device size
  - Order them to tell your story: main → features → premium

- [ ] **Add App Preview video** (Optional but recommended)
  - 15-30 seconds showing app in action
  - Can significantly improve conversion

- [ ] **Fill in Version Information**
  - Description: Copy from APP_STORE_METADATA.md
  - Keywords: Copy from APP_STORE_METADATA.md
  - What's New: Copy from APP_STORE_METADATA.md
  - Support URL: https://jaayshwaah.github.io/intouch/support
  - Marketing URL: https://jaayshwaah.github.io/intouch/

- [ ] **Set Age Rating**
  - Complete the age rating questionnaire
  - Should be 4+ (no objectionable content)

- [ ] **Add Localizations** (Optional for v1.0)
  - You have 7 languages in your app!
  - Consider adding localized metadata for better reach
  - Can be added in future updates

### 9. App Review Information

- [ ] **Contact Information**
  - First Name: Josh
  - Last Name: King
  - Phone: [Your phone number]
  - Email: support@intouch.app (make sure this is active!)

- [ ] **Demo Account** (if app requires sign-in)
  - Your app doesn't require this ✅

- [ ] **Notes for Reviewer**
```
InTouch helps users stay connected with friends and family through daily reminders and random contact suggestions.

To test the app:
1. Grant contacts permission when prompted
2. Tap the spin button to get a random contact suggestion
3. You can test the premium subscription in sandbox mode
4. Daily notifications can be enabled in Settings

The app requests contacts permission to provide its core functionality - suggesting people to reach out to. All data stays on device.

Premium subscription testing:
- Monthly: $2.99
- Yearly: $19.99
- Sandbox tester account will be used for purchase testing

Thank you for reviewing InTouch!
```

### 10. Final Verification

- [ ] **Verify support email is active**
  - support@intouch.app should be monitored
  - Set up auto-responder if needed

- [ ] **Test all links**
  - Privacy policy loads correctly
  - Terms of service loads correctly
  - Support page loads correctly

- [ ] **Double-check pricing**
  - Monthly: $2.99
  - Yearly: $19.99
  - Confirm both are active in App Store Connect

- [ ] **Review App Privacy details**
  - Confirm "No data collected" is accurate
  - This is important for user trust!

### 11. Submit for Review

- [ ] **Submit app for review**
  - Click "Add for Review" in App Store Connect
  - Review all information one last time
  - Click "Submit for Review"

- [ ] **Wait for review**
  - Typical review time: 24-48 hours
  - Can take up to 7 days during busy periods
  - Check email for updates

---

## 📱 Post-Submission

### If Approved ✅

- [ ] **Celebrate!** 🎉
- [ ] **Set release option**
  - Manual release (you control when it goes live)
  - Automatic release (goes live immediately after approval)
- [ ] **Prepare marketing materials**
  - Social media posts
  - Email to friends/family
  - Product Hunt launch (optional)
- [ ] **Monitor reviews and ratings**
  - Respond to user feedback
  - Track crashes in App Store Connect
- [ ] **Plan next update**
  - Address any issues users report
  - Add new features based on feedback

### If Rejected ❌

- [ ] **Read rejection reason carefully**
- [ ] **Fix the issues mentioned**
- [ ] **Respond in Resolution Center if clarification needed**
- [ ] **Upload new build if code changes required**
- [ ] **Resubmit for review**

**Common rejection reasons:**
- Missing privacy policy (you have this ✅)
- Inaccurate App Privacy details
- Broken links or crashes
- Confusing user interface
- Missing subscription management info
- Misleading marketing text

---

## 🎯 Quick Tips

**Before you submit:**
1. Test on multiple iOS versions (16.0, 17.x, 18.x)
2. Test on different device sizes (iPhone SE, Pro, Pro Max, iPad)
3. Ask friends to beta test via TestFlight
4. Make sure all text is free of typos
5. Ensure the app works without internet (except IAP)

**TestFlight Beta (Optional but Recommended):**
- Upload same build to TestFlight first
- Invite 10-20 beta testers
- Get feedback before public release
- Fix any bugs discovered
- Upload final build to App Store

**Marketing Preparation:**
- Create social media accounts (@intouchapp?)
- Design promotional graphics
- Write launch announcement
- Prepare Product Hunt listing
- Set up analytics (post-launch)

---

## 📧 Support Checklist

Make sure support@intouch.app is set up to receive:
- [ ] General inquiries
- [ ] Bug reports
- [ ] Feature requests
- [ ] Subscription issues
- [ ] Refund requests (redirect to Apple)

---

## 🔗 Important Links

- App Store Connect: https://appstoreconnect.apple.com
- Developer Portal: https://developer.apple.com
- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- StoreKit Testing: https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_in_xcode

---

## 📊 Estimated Timeline

- GitHub Pages / Vercel setup: **15 minutes**
- App Store Connect setup: **1-2 hours**
- In-App Purchase configuration: **30 minutes**
- IAP testing: **30 minutes**
- Screenshot preparation: **2-4 hours**
- Archive & upload: **30 minutes**
- Filling in metadata: **1 hour**
- Review wait time: **24-48 hours**

**Total time before submission: 6-10 hours of work**

---

## ✨ You're Almost There!

You've completed the hardest part - building a great app! The submission process is just paperwork and screenshots. Take your time, double-check everything, and you'll be on the App Store soon.

Good luck! 🚀

---

**Questions?** Email Claude Code... just kidding, you know where to find me! 😄
