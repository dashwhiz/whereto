import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'app_translations.dart';
import '../screens/home/home_screen.dart';
import '../services/purchase_service.dart';
import '../services/connectivity_service.dart';
import '../services/logging_service.dart';

/// Main application widget
class App extends StatefulWidget {
  const App({super.key, required this.initialLocale});

  final Locale initialLocale;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister lifecycle observer
    WidgetsBinding.instance.removeObserver(this);

    // Dispose services
    _disposeServices();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Log lifecycle changes
    log.debug('App lifecycle state changed: $state');

    // If app is being detached or paused permanently, dispose services
    if (state == AppLifecycleState.detached) {
      _disposeServices();
    }
  }

  /// Dispose all services that need cleanup
  void _disposeServices() {
    log.info('Disposing services...');

    try {
      // Dispose purchase service
      purchaseService.dispose();

      // Dispose connectivity service
      connectivityService.dispose();

      log.info('✅ Services disposed successfully');
    } catch (e, s) {
      log.error('Error disposing services', e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'appName'.tr,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Translations
      translations: AppTranslations(),
      locale: widget.initialLocale,
      fallbackLocale: const Locale('en', 'US'),

      // Initial route
      home: const HomeScreen(),

      // Debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
