import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'hive_service.dart';
import 'logging_service.dart';
import '../models/language_option.dart';

/// Settings service for app preferences
/// Uses Hive for persistent storage
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _languageKey = 'language';
  static const String _countryKey = 'country';

  /// Available languages with their display names and locales
  static const Map<String, LanguageOption> availableLanguages = {
    'en_US': LanguageOption('English', 'en', 'US', '🇺🇸'),
    'de_DE': LanguageOption('Deutsch', 'de', 'DE', '🇩🇪'),
    'es_ES': LanguageOption('Español', 'es', 'ES', '🇪🇸'),
    'fr_FR': LanguageOption('Français', 'fr', 'FR', '🇫🇷'),
    'it_IT': LanguageOption('Italiano', 'it', 'IT', '🇮🇹'),
    'pt_PT': LanguageOption('Português', 'pt', 'PT', '🇵🇹'),
  };

  /// Get saved language from Hive
  Future<Locale> getSavedLanguage() async {
    final box = await hiveService.openBox<String>(HiveBoxes.settings);
    final languageCode = box.get(_languageKey, defaultValue: 'en');
    final countryCode = box.get(_countryKey, defaultValue: 'US');

    log.info('Loaded saved language: ${languageCode}_$countryCode');
    return Locale(languageCode!, countryCode!);
  }

  /// Save language preference to Hive
  Future<void> saveLanguage(Locale locale) async {
    final box = await hiveService.openBox<String>(HiveBoxes.settings);
    await box.put(_languageKey, locale.languageCode);
    await box.put(_countryKey, locale.countryCode ?? 'US');

    log.info('Saved language: ${locale.languageCode}_${locale.countryCode}');
  }

  /// Change app language and persist it
  Future<void> changeLanguage(String languageKey) async {
    final option = availableLanguages[languageKey];
    if (option == null) {
      log.warning('Unknown language key: $languageKey');
      return;
    }

    final locale = Locale(option.languageCode, option.countryCode);
    await saveLanguage(locale);
    Get.updateLocale(locale);

    log.info('Language changed to: ${option.displayName}');
  }

  /// Get current language display name
  String getCurrentLanguageName() {
    final currentLocale = Get.locale;
    if (currentLocale == null) return 'English';

    final key = '${currentLocale.languageCode}_${currentLocale.countryCode}';
    return availableLanguages[key]?.displayName ?? 'English';
  }

  /// Get current language key
  String getCurrentLanguageKey() {
    final currentLocale = Get.locale;
    if (currentLocale == null) return 'en_US';

    return '${currentLocale.languageCode}_${currentLocale.countryCode}';
  }
}

/// Global settings service instance
final settingsService = SettingsService();
