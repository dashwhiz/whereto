import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/connectivity_service.dart';
import '../services/hive_service.dart';
import '../services/logging_service.dart';
import '../services/settings_service.dart';
import '../services/location_service.dart';
import 'app.dart';

/// Environment configuration for the app
///
/// This class manages environment-specific configurations like:
/// - API endpoints
/// - Feature flags
/// - Logging settings
///
/// Usage:
/// - Call `dev()` or `prod()` in main.dart to initialize the app with the desired environment
/// - Access current environment via `Environment.instance`
class Environment {
  Environment({
    required this.name,
    this.loggingEnabled = true,
  });

  /// Singleton instance - set by calling dev() or prod()
  static late Environment instance;

  /// Environment name (e.g., "dev", "prod")
  final String name;

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

    // Initialize location service to detect user's region
    await locationService.init();

    log.info('✅ App initialized successfully');

    // Run the app
    runApp(App(initialLocale: initialLocale));
  }
}

// ============================================================================
// ENVIRONMENT INSTANCES
// ============================================================================

/// Development environment
///
/// Used for local development and testing
/// Features:
/// - Detailed logging enabled
final dev = Environment(
  name: 'dev',
  loggingEnabled: true,
);

/// Production environment
///
/// Used for App Store and Google Play releases
/// Features:
/// - Logging enabled
final prod = Environment(
  name: 'prod',
  loggingEnabled: true,
);
