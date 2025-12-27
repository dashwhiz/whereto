# Build Commands Reference

Quick reference for building and running your Flutter app in different environments.

## Table of Contents
- [Running in Development](#running-in-development)
- [Running in Production](#running-in-production)
- [Building Release Builds](#building-release-builds)
- [Code Generation](#code-generation)
- [Useful Commands](#useful-commands)

---

## Running in Development

### Default Run (Dev Environment)

```bash
# Simplest - runs in dev mode by default
flutter run

# Explicit dev mode
flutter run -t lib/run/dev.dart --flavor dev
```

### Dev with Specific Device

```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -t lib/run/dev.dart --flavor dev -d <device-id>

# Examples:
flutter run -t lib/run/dev.dart --flavor dev -d emulator-5554  # Android emulator
flutter run -t lib/run/dev.dart --flavor dev -d 00008020-001234567890  # iOS device
```

### Dev Debug vs Release

```bash
# Debug mode (default) - hot reload enabled, debug logs
flutter run -t lib/run/dev.dart --flavor dev

# Profile mode - performance profiling
flutter run -t lib/run/dev.dart --flavor dev --profile

# Release mode - optimized, no debug logs
flutter run -t lib/run/dev.dart --flavor dev --release
```

---

## Running in Production

### Run Prod in Debug Mode (for testing)

```bash
flutter run -t lib/run/prod.dart --flavor prod
```

### Run Prod in Release Mode

```bash
flutter run -t lib/run/prod.dart --flavor prod --release
```

**Note**: Use production environment ONLY when testing prod-specific features (like real Firebase project, real IAP products).

---

## Building Release Builds

### Android APK (for direct installation)

```bash
# Dev APK
flutter build apk \
  --release \
  -t lib/run/dev.dart \
  --flavor dev

# Prod APK
flutter build apk \
  --release \
  -t lib/run/prod.dart \
  --flavor prod
```

**Output**: `build/app/outputs/flutter-apk/app-prod-release.apk`

### Android App Bundle (for Play Store)

```bash
# Prod App Bundle (RECOMMENDED for Play Store)
flutter build appbundle \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Dev App Bundle (for internal testing)
flutter build appbundle \
  --release \
  -t lib/run/dev.dart \
  --flavor dev
```

**Output**: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

**Flags explained**:
- `--obfuscate`: Makes code harder to reverse engineer
- `--split-debug-info`: Generates symbol files for crash reports (store these!)

### iOS (requires Mac with Xcode)

```bash
# Dev build
flutter build ios \
  --release \
  -t lib/run/dev.dart \
  --flavor dev

# Prod build
flutter build ios \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Then**: Open `ios/Runner.xcworkspace` in Xcode and archive from there.

**Or use command line**:
```bash
# Archive and export IPA
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme prod \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/
```

---

## Code Generation

The template uses `json_serializable` for model serialization.

### Generate Serialization Code

```bash
# One-time generation
flutter pub run build_runner build

# Watch mode (auto-regenerates on file changes)
flutter pub run build_runner watch

# Clean and rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

**When to run**:
- After creating new model classes with `@JsonSerializable()`
- After modifying existing model fields
- If you see "missing generated files" errors

---

## Useful Commands

### Clean Build

```bash
# Clean Flutter build cache
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter build apk --release -t lib/run/prod.dart --flavor prod
```

### Update Dependencies

```bash
# Get latest compatible versions
flutter pub get

# Upgrade to latest versions
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Analyze Code

```bash
# Run static analysis
flutter analyze

# Format code
flutter format lib/

# Fix auto-fixable issues
dart fix --apply
```

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/purchase_service_test.dart

# Run with coverage
flutter test --coverage
```

### Generate App Icons

```bash
# Make sure you have an icon at assets/icon/app_icon.png
flutter pub run flutter_launcher_icons
```

---

## IDE Run Configurations

The template includes pre-configured run configurations in `.run/` folder:

- **Dev-Debug.run.xml** - Development mode, hot reload enabled
- **Dev-Release.run.xml** - Development mode, release build
- **Prod-Debug.run.xml** - Production mode, hot reload enabled
- **Prod-Release.run.xml** - Production mode, release build

**To use in Android Studio / IntelliJ**:
1. These configs are auto-detected
2. Select from dropdown at top of IDE
3. Click Run

**To use in VS Code**:
Add to `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dev-Debug",
      "request": "launch",
      "type": "dart",
      "program": "lib/run/dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "Prod-Release",
      "request": "launch",
      "type": "dart",
      "program": "lib/run/prod.dart",
      "args": ["--flavor", "prod", "--release"]
    }
  ]
}
```

---

## Build for Different Architectures

### Android - Split APKs by Architecture

```bash
flutter build apk \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --split-per-abi
```

This creates separate APKs for:
- `app-armeabi-v7a-prod-release.apk` (32-bit ARM)
- `app-arm64-v8a-prod-release.apk` (64-bit ARM)
- `app-x86_64-prod-release.apk` (64-bit x86)

**Why**: Smaller download size for users (only downloads for their architecture)

### iOS - Universal vs Specific

```bash
# Build for all architectures (default)
flutter build ios --release -t lib/run/prod.dart --flavor prod

# Build for specific architecture (faster for testing)
flutter build ios --release --simulator  # Simulator only
```

---

## Deployment Checklist

### Before Building for Release

- [ ] Update version in `pubspec.yaml`
  ```yaml
  version: 1.0.1+2  # 1.0.1 = version name, 2 = build number
  ```
- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze` (fix any warnings)
- [ ] Run `flutter test` (all tests pass)
- [ ] Verify all TODOs are addressed
- [ ] Test on physical devices (iOS + Android)
- [ ] Test in prod environment with real accounts
- [ ] Update `CHANGELOG.md` (if you have one)

### Android Play Store Build

```bash
flutter build appbundle \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Then**:
1. Go to [Play Console](https://play.google.com/console)
2. Select your app
3. Go to "Release" → "Production" → "Create new release"
4. Upload `app-prod-release.aab`
5. Fill in release notes
6. Review and rollout

### iOS App Store Build

```bash
flutter build ios \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Then**:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Once archived, Window → Organizer
5. Select archive → "Distribute App"
6. Choose "App Store Connect"
7. Upload
8. Go to [App Store Connect](https://appstoreconnect.apple.com/)
9. Submit build for review

---

## Environment Variables

### Passing Extra Config at Build Time

```bash
# Custom define
flutter build apk \
  --release \
  -t lib/run/prod.dart \
  --flavor prod \
  --dart-define=API_URL=https://api.example.com

# Use in code:
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://default.com');
```

---

## Troubleshooting Build Issues

### "Flavor not found"

```bash
# Make sure flavor is specified correctly
flutter run -t lib/run/dev.dart --flavor dev  # lowercase!
```

### "No Firebase options found"

```bash
# Run flutterfire configure first
flutterfire configure --project=your-project-id
```

### "Build failed - Gradle error"

```bash
# Clean and rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk --release -t lib/run/prod.dart --flavor prod
```

### "iOS build failed - Provisioning profile"

1. Open Xcode
2. Select Runner target
3. Go to "Signing & Capabilities"
4. Fix any signing issues
5. Try building from Xcode first
6. Then try Flutter build command

---

## Quick Reference Table

| Task | Command |
|------|---------|
| Run dev (default) | `flutter run` |
| Run prod | `flutter run -t lib/run/prod.dart --flavor prod` |
| Build Android APK | `flutter build apk --release -t lib/run/prod.dart --flavor prod` |
| Build Android AAB | `flutter build appbundle --release -t lib/run/prod.dart --flavor prod` |
| Build iOS | `flutter build ios --release -t lib/run/prod.dart --flavor prod` |
| Generate models | `flutter pub run build_runner build` |
| Clean build | `flutter clean && flutter pub get` |
| Run tests | `flutter test` |
| Analyze code | `flutter analyze` |

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze
        run: flutter analyze

      - name: Run tests
        run: flutter test

      - name: Build APK
        run: flutter build apk --release -t lib/run/prod.dart --flavor prod

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-prod-release.apk
```

---

## Next Steps

- See `PER_APP_SETUP.md` for complete app setup guide
- See `TESTING_GUIDE.md` for testing IAP and push notifications
- Check out Flutter's [Build and release documentation](https://docs.flutter.dev/deployment)
