# Flutter Template Project

A production-ready Flutter template with clean architecture, GetX state management, In-App Purchases, Push Notifications, and comprehensive utilities to ship apps faster.

**Mobile-focused**: This template is optimized for iOS and Android development with support for 30+ apps from a single template.

## Features

- **GetX State Management**: Reactive state management and routing
- **Clean Architecture**: Organized folder structure with separation of concerns
- **In-App Purchase (Native)**: Official plugin with automatic restore across devices - $0/month cost
- **Push Notifications (FCM)**: Firebase Cloud Messaging with full handler support
- **Entitlement System**: Track user purchases with reactive observables
- **Paywall Screen**: Ready-to-use product display and purchase flow
- **Environment Management**: Dev/Prod configurations with flavors and schemes
- **Dark Theme**: Beautiful Material 3 dark theme with customizable colors
- **Internationalization**: Built-in 6 languages (English, German, Spanish, French, Italian, Portuguese)
- **API Integration**: Ready-to-use HTTP client with automatic connectivity checking and error handling
- **Connectivity Monitoring**: Automatic internet connection checking before API calls
- **Progress & Error Handling**: Centralized progress listeners and error notifications
- **Logging Service**: Comprehensive logging for debugging API calls, errors, and app flow
- **Local Storage (Hive)**: Fast and efficient local database for caching and persistence
- **App Icon Generator**: Easy icon generation for iOS and Android with flutter_launcher_icons
- **Utilities**: Date/time formatters, extensions, and helper functions

## Tech Stack

- **Flutter SDK**: ^3.9.2
- **GetX**: ^4.7.2 - State management & navigation
- **HTTP**: ^1.2.2 - API calls
- **connectivity_plus**: ^7.0.0 - Network connectivity monitoring
- **Hive**: ^2.2.3 - Local database
- **firebase_core**: ^3.8.1 - Firebase initialization
- **firebase_messaging**: ^15.1.3 - Push notifications (FCM)
- **in_app_purchase**: ^3.2.0 - Native in-app purchases (iOS & Android)
- **Logger**: ^2.5.0 - Debugging and logging
- **flutter_spinkit**: ^5.2.1 - Loading animations
- **flutter_launcher_icons**: ^0.14.2 - App icon generation
- **json_serializable**: ^6.9.5 - JSON parsing
- **intl**: ^0.20.2 - Date formatting

## Project Structure

```
lib/
├── api/                    # API layer
│   ├── server_api.dart     # Centralized API client
│   ├── api_headers.dart    # HTTP headers
│   └── api_status_codes.dart # HTTP status code constants
├── app/                    # App configuration
│   ├── app.dart            # Main app widget
│   ├── environments.dart   # 🆕 Environment management (dev/prod)
│   ├── app_colors.dart     # Color palette
│   ├── app_theme.dart      # Theme configuration (Material 3)
│   ├── app_fonts.dart      # Font definitions
│   ├── app_routes.dart     # Routing configuration
│   ├── app_controller.dart # Base controller for GetX
│   ├── app_translations.dart # i18n configuration
│   ├── translations/       # Translation files (one per language)
│   │   ├── en_us.dart      # English translations
│   │   ├── de_de.dart      # German translations
│   │   ├── es_es.dart      # Spanish translations
│   │   ├── fr_fr.dart      # French translations
│   │   ├── it_it.dart      # Italian translations
│   │   └── pt_pt.dart      # Portuguese translations
│   ├── app_progress_listeners.dart # Progress indication system
│   └── app_error_listeners.dart    # Error handling system
├── run/                    # 🆕 Environment entry points
│   ├── dev.dart            # Development environment entry
│   └── prod.dart           # Production environment entry
├── models/                 # Data models
│   ├── language_option.dart # Language option model
│   ├── user.dart           # User model (example)
│   ├── user.g.dart         # Generated JSON serialization
│   ├── purchase.dart       # 🆕 Purchase model
│   ├── entitlement.dart    # 🆕 Entitlement model
│   └── product_offering.dart # 🆕 IAP product model
├── repositories/           # Data repositories
│   ├── user_repository.dart # User repository (example)
│   └── purchase_repository.dart # 🆕 Purchase data access
├── screens/                # UI screens
│   ├── home/              # Feature-based organization
│   │   └── home_screen.dart # Home screen with animated feature showcase
│   └── purchase/          # 🆕 Purchase screens
│       └── paywall_screen.dart # Product display & purchase flow
├── services/              # Business services
│   ├── logging_service.dart      # Logging service (Logger wrapper)
│   ├── hive_service.dart         # Local storage service
│   ├── connectivity_service.dart # Network connectivity monitoring
│   ├── settings_service.dart     # App settings & preferences
│   ├── push_notification_service.dart # 🆕 FCM push notifications
│   ├── purchase_service.dart     # 🆕 Native in-app purchase
│   └── entitlement_service.dart  # 🆕 User entitlement tracking
├── utils/                 # Utilities
│   ├── operation_scope.dart # Async operation wrapper with connectivity check
│   ├── date_utils.dart      # Date/time utilities
│   └── extensions.dart      # Dart extensions (DateTime, String)
├── widgets/               # Reusable widgets
│   ├── app_loading.dart   # Loading indicator (SpinKit)
│   ├── app_dialog.dart    # Confirmation dialog
│   ├── app_future_builder.dart # Simplified FutureBuilder
│   └── premium_feature_button.dart # 🆕 Premium feature gate widget
└── main.dart              # Application entry point (calls dev() by default)

.run/                      # 🆕 IDE run configurations
├── Dev-Debug.run.xml
├── Dev-Release.run.xml
├── Prod-Debug.run.xml
└── Prod-Release.run.xml

docs/                      # 🆕 Comprehensive documentation
├── PER_APP_SETUP.md       # Complete setup guide for each app
├── TESTING_GUIDE.md       # IAP & push notification testing
└── BUILD_COMMANDS.md      # Build commands reference
```

## 📚 Documentation

Comprehensive guides for setting up and using this template:

- **[Per-App Setup Guide](docs/PER_APP_SETUP.md)** - Complete checklist for creating each new app from this template (Firebase, IAP setup, product configuration)
- **[Testing Guide](docs/TESTING_GUIDE.md)** - How to test In-App Purchases and Push Notifications (sandbox testing, device changes, restore purchases)
- **[Build Commands Reference](docs/BUILD_COMMANDS.md)** - All build commands for dev/prod environments, different platforms, and CI/CD integration

**Time Estimates**:
- First app from template: 2-3 hours (learning + setup)
- Subsequent apps: 30-60 minutes (mostly App Store/Play Console setup)

## Quick Start

### 1. Clone the Template

```bash
git clone <repository-url>
cd my_flutter_template
```

### 2. Rename the Project

Use the automated rename script to set up your new project:

```bash
./rename_project.sh your_project_name
```

This will:
- Update `pubspec.yaml`
- Update Android package names
- Update iOS bundle identifiers
- Update all Dart imports
- Clean and rebuild the project

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code (for models with JSON serialization)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```bash
# Run in development mode (default)
flutter run

# Or explicitly specify dev environment
flutter run -t lib/run/dev.dart --flavor dev

# Run in production mode
flutter run -t lib/run/prod.dart --flavor prod
```

**Note**: Push notifications and IAP won't work until you complete Firebase and App Store/Play Console setup (see [Per-App Setup Guide](docs/PER_APP_SETUP.md)). But you can test the UI and navigation right away!

## Key Patterns

### 1. Screen + Controller Pattern

Controllers and screens are defined in the same file for better organization. **Convention**: Controller (business logic) comes first, then Screen (UI).

```dart
// =============================================================================
// CONTROLLER - Business Logic
// =============================================================================

class PaywallController extends AppController {
  // State, methods, business logic
  final products = <Product>[].obs;

  Future<void> fetchProducts() async {
    // Business logic here
  }
}

// =============================================================================
// SCREEN - UI / Build Method
// =============================================================================

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaywallController());
    // Build UI using controller
  }
}
```

**Why this order?**
- Business logic is more important than presentation
- Read top-to-bottom: understand what it does, then how it looks
- Controllers can be tested independently
- Easier to find logic when debugging

**Note**: Not all screens need controllers. The home screen, for example, is a simple StatefulWidget with local animation state.

### 2. Async Operations with scope()

Wrap API calls with automatic progress indication and error handling:

```dart
Future<void> fetchData() async {
  final operation = await scope(
    scope: () => repository.getData(),
    progressListener: _progressListener,
    errorListener: _errorListener,
  );

  if (operation.success) {
    // Handle success
  }
}
```

The `DefaultProgressListener` automatically shows "Loading..." (translated) during operations.

### 3. Navigation

Centralized, type-safe navigation:

```dart
AppRoutes.navigateToHome();
AppRoutes.navigateToHomeAndClearStack();
```

### 4. Translations

Easy internationalization with GetX and persistent language preferences:

```dart
// Use translations in UI
Text('welcome'.tr);  // Automatically translated

// Change language (automatically saved to Hive)
await settingsService.changeLanguage('de_DE');

// Get current language name
final name = settingsService.getCurrentLanguageName();  // "Deutsch"

// Language preference persists across app restarts
```

**Features:**
- 6 languages included (English, German, Spanish, French, Italian, Portuguese)
- Language preference saved to local storage (Hive)
- Restored automatically on app startup
- Common strings (errors, notifications, buttons) translated in all languages
- Home screen features are English-only (template showcase)

### 5. Notifications

Built-in notification helpers:

```dart
SuccessNotification.show('Data saved!');
WarningNotification.show('Check your input');
```

### 6. Dialogs

Reusable confirmation dialogs:

```dart
final confirmed = await AppDialog.show(
  context: context,
  icon: Icons.delete,
  title: 'Delete Item?',
  message: 'This cannot be undone',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDestructive: true,
);
```

## App Icons

Generate custom app icons for iOS and Android easily:

1. **Add your icon**: Place a 1024x1024 PNG image at `assets/icon/app_icon.png`

2. **Generate icons**:
```bash
flutter pub run flutter_launcher_icons
```

This automatically creates all required icon sizes for both iOS and Android!

**Customize** the icon configuration in `pubspec.yaml` under `flutter_launcher_icons` section.

See `assets/icon/README.md` for detailed instructions and tips.

## Customization

### Colors

Edit `lib/app/app_colors.dart` to customize your color palette:

```dart
static const Color primary = Color(0xFF6750A4);  // Change to your brand color
static const Color accent = Color(0xFF7B61FF);
```

### Loading Animation

Change the loading animation in `lib/widgets/app_loading.dart`:

```dart
// Replace SpinKitWave with any other SpinKit widget
SpinKitCircle(color: AppColors.primary, size: 60.0),
```

Available animations: SpinKitWave, SpinKitCircle, SpinKitFadingCircle, SpinKitRotatingCircle, SpinKitPulse, etc.

### Fonts

To use different fonts:
1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`
3. Update `lib/app/app_fonts.dart`

### Theme

Customize the theme in `lib/app/app_theme.dart`:

```dart
static ThemeData get darkTheme => ThemeData(
  // Customize theme properties
);
```

## Adding New Languages

The template includes 6 languages by default:
- 🇺🇸 English (en_US)
- 🇩🇪 German (de_DE)
- 🇪🇸 Spanish (es_ES)
- 🇫🇷 French (fr_FR)
- 🇮🇹 Italian (it_IT)
- 🇵🇹 Portuguese (pt_PT)

Each language is in its own file in `lib/app/translations/` for better organization.

To add more languages:

1. Create a new translation file in `lib/app/translations/` (e.g., `ja_jp.dart`):

```dart
/// Japanese (JP) translations
const Map<String, String> jaJP = {
  'appName': 'マイFlutterテンプレート',
  'welcome': 'ようこそ',
  'ok': 'OK',
  // Add all translation keys...
};
```

2. Import the new file in `lib/app/app_translations.dart`:

```dart
import 'translations/ja_jp.dart';
```

3. Add it to the keys map in `lib/app/app_translations.dart`:

```dart
@override
Map<String, Map<String, String>> get keys => {
  'en_US': enUS,
  'de_DE': deDE,
  'es_ES': esES,
  'fr_FR': frFR,
  'it_IT': itIT,
  'pt_PT': ptPT,
  'ja_JP': jaJP,  // Add new language
};
```

Tip: Copy an existing translation file as a template to ensure you have all required keys.

## API Integration

### Setting up your API

Update `lib/api/server_api.dart`:

```dart
ServerAPI({this.baseUrl = 'https://your-api.com'});
```

### Adding API Endpoints

```dart
Future<Map<String, dynamic>> getProfile(String token) {
  return get(
    '/user/profile',
    headers: ApiHeaders.authorizedHeaders(token),
  );
}
```

### Using in Repository

```dart
class UserRepository {
  UserRepository(this._serverAPI);
  final ServerAPI _serverAPI;

  Future<User> getUserProfile(String token) async {
    final response = await _serverAPI.getProfile(token);
    return User.fromJson(response);
  }
}
```

## Date/Time Utilities

Comprehensive date formatting utilities:

```dart
// Format dates
formatDdMmYyyy(DateTime.now());  // 03/11/2025
formatMmmDYyyy(DateTime.now());  // November 3, 2025

// Extensions
DateTime.now().formatHhMm;  // 14:30
DateTime.now().isToday;     // true/false
DateTime.now().startOfDay;  // Today at 00:00
```

## Logging

The template includes a powerful logging service for debugging:

```dart
import 'package:my_flutter_template/services/logging_service.dart';

// Basic logging
log.debug('Debug message');
log.info('Info message');
log.warning('Warning message');
log.error('Error message', error, stackTrace);

// API logging (automatically logged in ServerAPI)
log.apiRequest('GET', 'https://api.example.com/users');
log.apiResponse('https://api.example.com/users', 200);

// Navigation logging
log.navigation('HomeScreen', 'ProfileScreen');

// Logging with scope()
final operation = await scope(
  scope: () => repository.getData(),
  progressListener: _progressListener,
  errorListener: _errorListener,
  logLabel: 'Fetch user data',  // Logs start/end/errors
);
```

## Connectivity Monitoring

The template provides optional connectivity checking with an offline-first approach:

```dart
import 'package:my_flutter_template/services/connectivity_service.dart';

// Check current connectivity status
if (connectivityService.isConnected) {
  // Device is connected to internet
}

// Manually check connectivity
final isConnected = await connectivityService.checkConnectivity();

// Optional connectivity check in scope() - only when explicitly needed
final operation = await scope(
  scope: () => repository.fetchData(),
  progressListener: _progressListener,
  errorListener: _errorListener,
  requireConnectivity: true,  // Opt-in connectivity check
);
// If offline, shows "No internet connection" error to user
```

**Key Features:**
- **Offline-first by default** - operations work without internet unless explicitly required
- Opt-in connectivity checking with `requireConnectivity: true`
- No unnecessary blocking for local operations (IAP, Hive, etc.)
- Centralized error handling with translated messages
- Real-time connection status monitoring
- Single place to manage all connectivity logic

## Local Storage with Hive

Fast and efficient local storage:

```dart
import 'package:my_flutter_template/services/hive_service.dart';

// Open a box
final settingsBox = await hiveService.openBox<dynamic>(HiveBoxes.settings);

// Store data
settingsBox.put('darkMode', true);
settingsBox.put('language', 'en');

// Retrieve data
final darkMode = settingsBox.get('darkMode', defaultValue: false);

// Delete data
settingsBox.delete('darkMode');

// Close box
await hiveService.closeBox(HiveBoxes.settings);

// For custom objects, use Hive adapters with code generation
```

## Building for Production

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Tips

1. **Keep controllers in the same file as screens** for better organization
2. **Use scope() for all API calls** to get automatic error handling
3. **Customize colors early** in the development process
4. **Add translations as you go** rather than at the end
5. **Use the repository pattern** to keep API logic separate from UI
6. **Generate JSON code** after adding/modifying models

## License

MIT License - feel free to use this template for any project.
