# Testing Guide

Complete guide for testing In-App Purchases and Push Notifications.

## Table of Contents
- [Testing In-App Purchases](#testing-in-app-purchases)
  - [iOS (Sandbox)](#ios-sandbox)
  - [Android (Test Accounts)](#android-test-accounts)
- [Testing Push Notifications](#testing-push-notifications)
- [Testing Device Changes](#testing-device-changes)
- [Common Issues](#common-issues)

---

## Testing In-App Purchases

### iOS (Sandbox)

#### 1. Create Sandbox Test Account

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to "Users and Access"
3. Click "Sandbox" tab
4. Click "+" to add tester
5. Create account with:
   - Unique email (can be fake: test+sandbox1@example.com)
   - Password
   - Country/Region (match your test region)

#### 2. Sign Out of Real App Store

**IMPORTANT**: You must sign out of your real App Store account before testing!

On iPhone:
1. Settings → [Your Name] → Media & Purchases
2. Tap "Sign Out"
3. Do NOT sign in with sandbox account here - you'll be prompted during purchase

#### 3. Test Purchase Flow

1. Run app in Debug mode:
   ```bash
   flutter run -t lib/run/dev.dart --flavor dev
   ```

2. In the app:
   - Navigate to your paywall screen
   - Tap a product to purchase
   - You'll be prompted to sign in
   - Use your sandbox test account
   - Complete the test purchase (you won't be charged)

3. Verify:
   - Purchase completes successfully
   - Entitlements are unlocked
   - Features become accessible

#### 4. Test Restore Purchases

1. On the SAME DEVICE:
   - Navigate to your paywall screen
   - Tap "Restore" button
   - Should restore your previous purchase

2. On a DIFFERENT DEVICE (or after app reinstall):
   - Install app on new device
   - Navigate to paywall → Tap "Restore"
   - Sign in with same sandbox account
   - Purchases should restore automatically

#### 5. Reset Sandbox Purchase History (Optional)

To test purchase flow again:
1. Settings → App Store
2. Scroll to bottom
3. Tap "Sandbox Account"
4. Tap "Manage" → "Clear Purchase History"

---

### Android (Test Accounts)

#### 1. Add License Testers

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to "Setup" → "License testing"
4. Add Gmail addresses of test accounts
5. Choose "License response": **Licensed**

#### 2. Upload App to Internal Testing

You MUST have at least one build in internal testing before IAP works:

```bash
# Build release bundle
flutter build appbundle --release -t lib/run/prod.dart --flavor prod

# Upload to Play Console → Internal testing
```

#### 3. Opt In to Internal Testing

1. In Play Console, go to "Release" → "Testing" → "Internal testing"
2. Copy the opt-in URL
3. Open URL on your test device (signed in with test Gmail account)
4. Opt in to testing
5. Install the app from Play Store

#### 4. Test Purchase Flow

1. Open the app on test device
2. Navigate to your paywall screen
3. Tap a product to purchase
4. Complete test purchase
   - Test accounts are NOT charged
   - Purchase goes through real payment flow but no money is deducted

5. Verify purchase succeeded

#### 5. Test Restore Purchases

- Uninstall app
- Reinstall app
- Navigate to paywall → Tap "Restore"
- Should restore purchases tied to your Google Play account

---

## Testing Push Notifications

### 1. Get FCM Token

You can get the FCM token programmatically in your app:

```dart
// In any screen/controller where you need the token
final token = await pushNotificationService.getToken();
if (token != null) {
  log.info('FCM Token: $token');
  // Copy to clipboard or display in UI
  await Clipboard.setData(ClipboardData(text: token));
}
```

Or check your console logs when the app starts - the token is logged during initialization.

### 2. Send Test Notification from Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to "Engage" → "Cloud Messaging"
4. Click "Send your first message"
5. Fill in:
   - Notification title
   - Notification text
6. Click "Send test message"
7. Paste the FCM token from step 1
8. Click "Test"

### 3. Verify Notification Behavior

**App in Foreground:**
- Notification appears as snackbar at top
- Tap to dismiss

**App in Background:**
- Notification appears in notification tray
- Tap notification → app opens

**App Terminated:**
- Notification appears in notification tray
- Tap notification → app launches

### 4. Test Notification Data/Deep Links

To test navigation from notifications:

1. In Firebase Console, when sending notification:
   - Click "Additional options"
   - Add custom data:
     - Key: `screen`
     - Value: `profile` (or any route)

2. Implement handler in `push_notification_service.dart`:
   ```dart
   if (data['screen'] == 'profile') {
     Get.toNamed('/profile');
   }
   ```

---

## Testing Device Changes

This is THE MOST IMPORTANT test - it verifies purchases persist across devices!

### Scenario 1: New Device (Same User)

**iOS:**
1. Purchase premium on Device A (iPhone 12)
2. Install app on Device B (iPhone 13)
3. Sign in with same Apple ID
4. Open app → Tap "Restore Purchases"
5. **VERIFY**: Premium features unlocked on Device B

**Android:**
1. Purchase premium on Device A (Pixel 6)
2. Install app on Device B (Samsung S21)
3. Sign in with same Google account
4. Open app → Tap "Restore Purchases"
5. **VERIFY**: Premium features unlocked on Device B

### Scenario 2: App Reinstall

1. Purchase premium
2. Uninstall app completely
3. Reinstall app
4. Open app → Tap "Restore Purchases"
5. **VERIFY**: Premium features restored

### Scenario 3: No Purchases to Restore

1. Use fresh device/account with no purchases
2. Tap "Restore Purchases"
3. **VERIFY**: Shows "No purchases found to restore" message

---

## Testing in Dev vs Prod Environments

### Dev Environment
- Uses `_dev` suffix product IDs
- Uses dev Firebase project
- Sandbox/test purchases only

```bash
flutter run -t lib/run/dev.dart --flavor dev
```

### Prod Environment
- Uses real product IDs
- Uses prod Firebase project
- Real purchases (but still testable with test accounts)

```bash
flutter run -t lib/run/prod.dart --flavor prod --release
```

---

## Common Issues

### iOS Issues

**Issue**: "Cannot connect to App Store"
- **Solution**: Make sure you're signed OUT of real App Store account in Settings

**Issue**: Products not loading
- **Solution**:
  - Verify products exist in App Store Connect
  - Check they're in "Ready to Submit" status
  - Product IDs must match exactly (including bundle ID prefix)

**Issue**: "This is not a test user account"
- **Solution**: Sign out completely, restart app, try again with correct sandbox account

**Issue**: Restore doesn't work
- **Solution**: Make sure you're using same Apple ID that made purchase

### Android Issues

**Issue**: "Item not available for purchase"
- **Solution**:
  - Verify app is uploaded to at least internal testing
  - Check that products are "Active" in Play Console
  - Make sure test account has opted into internal testing

**Issue**: "Authentication required"
- **Solution**: Sign in with Gmail account that's added as license tester

**Issue**: Products show $0.00
- **Solution**: This is normal for test accounts - purchase will still work

**Issue**: Restore doesn't find purchases
- **Solution**:
  - Verify same Google Play account on both devices
  - Check that purchase was actually completed (check Play Store purchase history)

### Firebase Issues

**Issue**: Push notifications not working on iOS
- **Solution**:
  - Check APNs key is uploaded to Firebase
  - Verify notification permissions granted
  - Check device has internet connection

**Issue**: Notifications not received when app is terminated
- **Solution**: This is normal iOS behavior if app was force-quit. Notifications work after natural app close.

**Issue**: FCM token not generating
- **Solution**: Verify Firebase is initialized correctly and `google-services.json` / `GoogleService-Info.plist` are present

---

## Testing Checklist

Before releasing to production, verify:

### In-App Purchase
- [ ] Products load correctly
- [ ] Purchase flow completes successfully
- [ ] Purchased features unlock
- [ ] Purchase persists after app restart
- [ ] Restore purchases works on same device
- [ ] Restore purchases works on different device
- [ ] Restore purchases works after reinstall
- [ ] Handles purchase cancellation gracefully
- [ ] Handles failed purchases gracefully
- [ ] Subscription auto-renewal works (wait 24 hours)

### Push Notifications
- [ ] Token generates on first launch
- [ ] Foreground notification shows
- [ ] Background notification shows
- [ ] Tapping notification opens app
- [ ] Notification data/deep links work
- [ ] Works on both iOS and Android
- [ ] Works after app reinstall

### Multi-Device
- [ ] Same user can access purchases on multiple devices
- [ ] Restore purchases finds all previous purchases
- [ ] No duplicate purchases created

---

## Tips for Efficient Testing

1. **Use Multiple Test Accounts**: Create 2-3 sandbox/test accounts to test different scenarios

2. **Test on Real Devices**: Simulator/Emulator IAP doesn't work properly - always test on physical devices

3. **Keep Test Devices**: Maintain one iOS and one Android device specifically for testing

4. **Document Test Accounts**: Keep a list of your test accounts and their purchase history

5. **Test Early and Often**: Don't wait until release to test IAP - test during development

6. **Use Logging**: Check logs to understand what's happening:
   ```bash
   flutter logs | grep -i purchase
   flutter logs | grep -i firebase
   ```

7. **Clear Data Between Tests**: When testing restore, actually uninstall and reinstall - don't just clear app data

---

## Support Resources

- [Apple - Testing In-App Purchases](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases)
- [Google - Test In-App Purchases](https://developer.android.com/google/play/billing/test)
- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
