import 'package:flutter/material.dart';
import 'hive_service.dart';
import 'logging_service.dart';

/// Settings service for app preferences
/// Uses Hive for persistent storage
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _languageKey = 'language';
  static const String _countryKey = 'country';

  /// Get saved language from Hive (always returns English)
  Future<Locale> getSavedLanguage() async {
    return const Locale('en', 'US');
  }

  /// Save language preference to Hive
  Future<void> saveLanguage(Locale locale) async {
    final box = await hiveService.openBox<String>(HiveBoxes.settings);
    await box.put(_languageKey, locale.languageCode);
    await box.put(_countryKey, locale.countryCode ?? 'US');

    log.info('Saved language: ${locale.languageCode}_${locale.countryCode}');
  }
}

/// Global settings service instance
final settingsService = SettingsService();
