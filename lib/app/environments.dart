import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
// import 'package:firebase_core/firebase_core.dart'; // Uncomment after running flutterfire configure
import '../services/connectivity_service.dart';
import '../services/hive_service.dart';
import '../services/logging_service.dart';
import '../services/settings_service.dart';
import '../services/purchase_service.dart';
import '../services/entitlement_service.dart';
// import '../services/push_notification_service.dart'; // Uncomment after Firebase setup
import 'app.dart';

/// Environment configuration for the app
///
/// This class manages environment-specific configurations like:
/// - Firebase project settings
/// - In-App Purchase product IDs
/// - Feature flags
/// - Analytics settings
///
/// Usage:
/// - Call `dev()` or `prod()` in main.dart to initialize the app with the desired environment
/// - Access current environment via `Environment.instance`
class Environment {
  Environment({
    required this.name,
    required this.firebaseProjectId,
    required this.iapProductIds,
    required this.subscriptionProductIds,
    this.verificationEndpoint,
    this.analyticsEnabled = false,
    this.crashReportingEnabled = false,
    this.loggingEnabled = true,
  });

  /// Singleton instance - set by calling dev() or prod()
  static late Environment instance;

  /// Environment name (e.g., "dev", "prod")
  final String name;

  /// Firebase project ID
  final String firebaseProjectId;

  /// In-App Purchase product IDs for one-time purchases
  /// Format: ["premium_unlock", "pro_features"]
  /// Your script should update these to match each app's bundle ID
  /// e.g., "com.yourcompany.appname.premium_unlock"
  final List<String> iapProductIds;

  /// Subscription product IDs
  /// Format: ["monthly_subscription", "yearly_subscription"]
  final List<String> subscriptionProductIds;

  /// Backend endpoint for purchase verification (optional)
  /// Example: 'https://your-api.com/verify-purchase'
  /// TODO: Set this when implementing server-side verification
  /// See purchase_service.dart for implementation details
  final String? verificationEndpoint;

  /// Whether analytics should be enabled
  final bool analyticsEnabled;

  /// Whether crash reporting should be enabled
  final bool crashReportingEnabled;

  /// Whether detailed logging should be enabled
  final bool loggingEnabled;

  /// Check if this is the production environment
  bool get isProduction => this == prod;

  /// Check if this is the development environment
  bool get isDevelopment => this == dev;

  /// Initialize the app with this environment
  Future<void> call() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set this as the current environment
    Environment.instance = this;

    // Initialize logging
    log.init(level: loggingEnabled ? Level.debug : Level.warning);
    log.info('🚀 Initializing app in $name environment');

    // Initialize connectivity monitoring
    await connectivityService.init();

    // Initialize Hive for local storage
    await hiveService.init();

    // Get saved language preference
    final initialLocale = await settingsService.getSavedLanguage();

    // Initialize Firebase
    // TODO: Uncomment after running: flutterfire configure
    // await Firebase.initializeApp(
    //   options: this == prod
    //     ? DefaultFirebaseOptions.currentPlatform
    //     : DevFirebaseOptions.currentPlatform,
    // );

    // Initialize Push Notifications
    // TODO: Uncomment after Firebase setup
    // await pushNotificationService.init();
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Initialize In-App Purchase
    await purchaseService.init();

    // Check user entitlements
    await entitlementService.checkEntitlements();

    log.info('✅ App initialized successfully');

    // Run the app
    runApp(App(initialLocale: initialLocale));
  }
}

// ============================================================================
// ENVIRONMENT INSTANCES
// ============================================================================
// Your app rename script should update the product IDs below to match
// each app's bundle identifier.
// ============================================================================

/// Development environment
///
/// Used for local development and testing
/// Features:
/// - Separate Firebase project
/// - Test product IDs (with .dev suffix)
/// - Detailed logging enabled
/// - Analytics disabled
final dev = Environment(
  name: 'dev',
  firebaseProjectId: 'my-flutter-template-dev', // TODO: Update after Firebase setup
  iapProductIds: [
    'premium_unlock_dev',
    'pro_features_dev',
    // Add more test product IDs here
  ],
  subscriptionProductIds: [
    'monthly_subscription_dev',
    'yearly_subscription_dev',
  ],
  analyticsEnabled: false,
  crashReportingEnabled: false,
  loggingEnabled: true,
);

/// Production environment
///
/// Used for App Store and Google Play releases
/// Features:
/// - Production Firebase project
/// - Real product IDs
/// - Analytics enabled
/// - Crash reporting enabled
final prod = Environment(
  name: 'prod',
  firebaseProjectId: 'my-flutter-template-prod', // TODO: Update after Firebase setup
  iapProductIds: [
    'premium_unlock',
    'pro_features',
    // Add more real product IDs here
  ],
  subscriptionProductIds: [
    'monthly_subscription',
    'yearly_subscription',
  ],
  analyticsEnabled: true,
  crashReportingEnabled: true,
  loggingEnabled: true,
);
