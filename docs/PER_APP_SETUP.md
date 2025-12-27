# Per-App Setup Guide

This guide walks you through setting up a new app from this template.

## Table of Contents
- [Quick Start for Claude Code](#quick-start-for-claude-code)
- [1. Clone Template](#1-clone-template)
- [2. Rename App](#2-rename-app)
- [3. Firebase Setup](#3-firebase-setup)
- [4. In-App Purchase Setup](#4-in-app-purchase-setup)
- [5. Environment Configuration](#5-environment-configuration)
- [6. Build & Test](#6-build--test)

---

## Quick Start for Claude Code

**When starting a new app project with Claude Code, follow these steps:**

### First Time Setup (One Time)

1. **Clone the template repository**
   ```bash
   cp -r my_flutter_template my_new_app
   cd my_new_app
   ```

2. **Open in your IDE** and let Claude Code assist with:
   - Running the rename script for your new app
   - Installing dependencies
   - Understanding the project structure

3. **Firebase Setup** (Always required)
   - Create Firebase projects (dev + prod)
   - Run `flutterfire configure` for both environments
   - Uncomment Firebase initialization in `lib/app/environments.dart`

4. **Optional: In-App Purchase Setup** (if your app needs monetization)
   - Create products in App Store Connect and Google Play Console
   - Update product IDs in `lib/app/environments.dart`

### What Claude Code Can Help You With

Claude Code can assist with:
- ✅ Understanding the architecture and patterns
- ✅ Adding new features to your app
- ✅ Debugging issues
- ✅ Implementing business logic
- ✅ Creating new screens and controllers
- ✅ Modifying themes and styles
- ✅ Adding translations
- ✅ Troubleshooting build issues

### What You Need to Do Manually

Some tasks require web console access:
- ❌ Creating Firebase projects
- ❌ Setting up App Store Connect / Google Play Console
- ❌ Creating IAP products
- ❌ Managing certificates and provisioning profiles
- ❌ Uploading builds to stores

### First Steps After Cloning

1. Ask Claude Code to help you understand the project structure
2. Run the rename script with Claude Code's guidance
3. Set up Firebase (follow sections below)
4. Run `flutter pub get` and `flutter run` to verify everything works
5. Start building your app features!

---

## 1. Clone Template

```bash
# Copy the template
cp -r my_flutter_template my_new_app
cd my_new_app
```

---

## 2. Rename App

### Run Your Rename Script
```bash
# Replace with your actual rename script
./rename_script.sh "MyNewApp" "com.yourcompany.newapp"
```

### Manual Steps (if no script)
1. Update `pubspec.yaml` - change `name:` field
2. Update Android package name:
   - `android/app/build.gradle.kts` - `applicationId`
   - `android/app/src/main/AndroidManifest.xml` - package name
3. Update iOS bundle identifier:
   - Open `ios/Runner.xcodeproj` in Xcode
   - Update Bundle Identifier in project settings
4. Update app display names in build flavors:
   - `android/app/build.gradle.kts` - `resValue` lines
   - iOS: Edit scheme names in Xcode

---

## 3. Firebase Setup

### 3.1 Create Firebase Projects

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create **two projects** (dev and prod):
   - `my-new-app-dev`
   - `my-new-app-prod`

### 3.2 Add Apps to Firebase

**For each project (dev and prod):**

1. Add iOS app
   - Bundle ID: `com.yourcompany.newapp` (prod) or `com.yourcompany.newapp.dev` (dev)
   - Download `GoogleService-Info.plist`

2. Add Android app
   - Package name: `com.yourcompany.newapp` (prod) or `com.yourcompany.newapp.dev` (dev)
   - Download `google-services.json`

### 3.3 Configure Firebase in Flutter

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure for DEV environment
flutterfire configure \
  --project=my-new-app-dev \
  --out=lib/app/firebase_options_dev.dart \
  --platforms=ios,android

# Configure for PROD environment
flutterfire configure \
  --project=my-new-app-prod \
  --out=lib/app/firebase_options_prod.dart \
  --platforms=ios,android
```

### 3.4 Update Environment File

Edit `lib/app/environments.dart`:

```dart
final dev = Environment(
  firebaseProjectId: 'my-new-app-dev', // ← Update this
  // ...
);

final prod = Environment(
  firebaseProjectId: 'my-new-app-prod', // ← Update this
  // ...
);
```

### 3.5 Uncomment Firebase Code

In `lib/app/environments.dart`, uncomment:
```dart
import 'package:firebase_core/firebase_core.dart';
import '../services/push_notification_service.dart';

// In call() method:
await Firebase.initializeApp(options: ...);
await pushNotificationService.init();
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

---

## 4. In-App Purchase Setup

### 4.1 iOS - App Store Connect

1. **Create App in App Store Connect**
   - Go to [App Store Connect](https://appstoreconnect.apple.com/)
   - Create new app with your bundle ID

2. **Enable In-App Purchase Capability**
   - Open `ios/Runner.xcodeproj` in Xcode
   - Select Runner target
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "In-App Purchase"

3. **Create Products**
   - In App Store Connect, go to your app
   - Navigate to "Features" → "In-App Purchases"
   - Click "+" to create products
   - Create products matching your environment config:
     - `com.yourcompany.newapp.premium_unlock` (one-time)
     - `com.yourcompany.newapp.monthly_subscription` (subscription)

4. **Configure Sandbox Testing**
   - Go to "Users and Access" → "Sandbox Testers"
   - Create test accounts for testing purchases

### 4.2 Android - Google Play Console

1. **Create App in Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app

2. **Upload App to Internal Testing**
   ```bash
   flutter build appbundle --release -t lib/run/prod.dart --flavor prod
   ```
   - Upload the AAB to internal testing track
   - (Required before you can create products)

3. **Create Products**
   - In Play Console, go to "Monetize" → "Products" → "In-app products"
   - Create products:
     - `premium_unlock` (one-time)
     - `monthly_subscription` (subscription)
   - Set prices and descriptions

4. **Add License Testers**
   - Go to "Setup" → "License testing"
   - Add test Gmail accounts
   - These accounts can make test purchases

### 4.3 Update Environment Configuration

Edit `lib/app/environments.dart`:

```dart
final dev = Environment(
  iapProductIds: [
    'com.yourcompany.newapp.premium_unlock_dev',
    'com.yourcompany.newapp.pro_features_dev',
  ],
  subscriptionProductIds: [
    'com.yourcompany.newapp.monthly_subscription_dev',
  ],
  // ...
);

final prod = Environment(
  iapProductIds: [
    'com.yourcompany.newapp.premium_unlock',
    'com.yourcompany.newapp.pro_features',
  ],
  subscriptionProductIds: [
    'com.yourcompany.newapp.monthly_subscription',
  ],
  // ...
);
```

**Important**: Product IDs should match what you created in App Store Connect and Google Play Console!

---

## 5. Environment Configuration

### Update `.run` Configurations

The template includes run configurations. Make sure they reference the correct project:
- `.run/Dev-Debug.run.xml`
- `.run/Dev-Release.run.xml`
- `.run/Prod-Debug.run.xml`
- `.run/Prod-Release.run.xml`

These should work as-is, but verify `$PROJECT_DIR$` paths if needed.

### iOS Schemes (Optional)

To create separate iOS schemes for dev/prod:

1. Open `ios/Runner.xcodeproj` in Xcode
2. Product → Scheme → Manage Schemes
3. Duplicate "Runner" scheme, name it "Dev"
4. Duplicate "Runner" scheme, name it "Prod"
5. Edit each scheme:
   - Build Configuration: Set to Debug-dev, Release-dev (for Dev scheme)
   - Build Configuration: Set to Debug-prod, Release-prod (for Prod scheme)

---

## 6. Build & Test

### Run in Development Mode

```bash
# Default (dev mode)
flutter run

# Explicit dev mode
flutter run -t lib/run/dev.dart --flavor dev

# Or use IDE run configuration: Dev-Debug
```

### Test Features

1. **Push Notifications**
   - Use `pushNotificationService.getToken()` in your code
   - Send test notification from Firebase Console
   - Verify notification appears

2. **In-App Purchase**
   - Navigate to the paywall screen in your app
   - Verify products load correctly
   - Try test purchase with sandbox/test account
   - Test restore purchases functionality

3. **Template Patterns**
   - Test the home screen demo features:
     - Fetch Data (demonstrates scope() pattern)
     - Show Dialog (demonstrates AppDialog)
     - Success/Error notifications (demonstrates notification system)
   - Verify translations work correctly

4. **Multi-Language**
   - Use language selector in app bar
   - Verify app language changes and persists across restarts

### Build for Production

See `BUILD_COMMANDS.md` for detailed build instructions.

---

## Checklist

Use this checklist for each new app:

- [ ] Clone template
- [ ] Run rename script
- [ ] Create Firebase projects (dev + prod)
- [ ] Run `flutterfire configure` for both environments
- [ ] Update `lib/app/environments.dart` with Firebase project IDs
- [ ] Uncomment Firebase initialization code
- [ ] Create app in App Store Connect
- [ ] Enable In-App Purchase capability in Xcode
- [ ] Create IAP products in App Store Connect
- [ ] Create app in Google Play Console
- [ ] Upload initial build to internal testing
- [ ] Create IAP products in Google Play Console
- [ ] Update product IDs in `environments.dart`
- [ ] Test dev build
- [ ] Test IAP purchases (sandbox)
- [ ] Test push notifications
- [ ] Build prod release
- [ ] Submit to stores

---

## Troubleshooting

### Firebase not initializing
- Verify `firebase_options_dev.dart` and `firebase_options_prod.dart` exist
- Check that Firebase imports are uncommented in `environments.dart`
- Make sure you ran `flutterfire configure` for correct package name/bundle ID

### IAP products not loading
- Verify products exist in App Store Connect / Play Console
- Check product IDs match exactly in `environments.dart`
- For iOS: Verify In-App Purchase capability is enabled in Xcode
- For Android: Verify app is uploaded to at least internal testing track

### Push notifications not working
- iOS: Check notification permissions were granted
- Android: Verify `google-services.json` is in `android/app/`
- Check Firebase Cloud Messaging is enabled in Firebase Console

---

## Time Estimate

- **First app**: ~2-3 hours (learning curve)
- **Subsequent apps**: ~30-60 minutes

Most time is spent on store setup and product creation, not code changes!
