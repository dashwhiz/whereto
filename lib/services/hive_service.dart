import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logging_service.dart';

/// Centralized Hive service for local storage
/// Provides easy access to Hive boxes for storing data locally
///
/// **Security:** Supports encrypted boxes for sensitive data (purchases, entitlements)
/// Encryption keys are stored in secure storage (Keychain on iOS, KeyStore on Android)
class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const _secureStorage = FlutterSecureStorage();
  static const _encryptionKeyStorageKey = 'hive_encryption_key';

  /// Initialize Hive
  /// Call this in main() before runApp()
  Future<void> init() async {
    log.info('Initializing Hive...');
    await Hive.initFlutter();
    log.info('Hive initialized successfully');
  }

  /// Get or create encryption key for Hive
  /// Key is stored securely in device's secure storage
  Future<List<int>> _getOrCreateEncryptionKey() async {
    try {
      // Try to read existing key
      final existingKey = await _secureStorage.read(key: _encryptionKeyStorageKey);

      if (existingKey != null) {
        // Decode existing key from base64
        return base64.decode(existingKey);
      }

      // Generate new 256-bit encryption key
      final newKey = Hive.generateSecureKey();

      // Store key securely
      await _secureStorage.write(
        key: _encryptionKeyStorageKey,
        value: base64.encode(newKey),
      );

      log.info('🔐 Generated new Hive encryption key');
      return newKey;
    } catch (e) {
      log.error('Failed to manage encryption key', e);
      rethrow;
    }
  }

  /// Open a box (creates if doesn't exist)
  ///
  /// Set [encrypted] to true for sensitive data (purchases, entitlements)
  /// Encrypted boxes use AES-256 encryption with keys stored in secure storage
  ///
  /// Example:
  /// ```dart
  /// // Regular box
  /// final settingsBox = await hiveService.openBox<dynamic>('settings');
  ///
  /// // Encrypted box (for purchases)
  /// final purchasesBox = await hiveService.openBox<dynamic>(
  ///   'purchases',
  ///   encrypted: true,
  /// );
  /// ```
  Future<Box<T>> openBox<T>(String boxName, {bool encrypted = false}) async {
    log.debug('Opening Hive box: $boxName ${encrypted ? "(encrypted)" : ""}');

    if (encrypted) {
      // Get encryption key and open encrypted box
      final encryptionKey = await _getOrCreateEncryptionKey();
      final encryptionCipher = HiveAesCipher(encryptionKey);

      return await Hive.openBox<T>(
        boxName,
        encryptionCipher: encryptionCipher,
      );
    }

    // Open regular box
    return await Hive.openBox<T>(boxName);
  }

  /// Get an already opened box
  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Check if a box is open
  bool isBoxOpen(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  /// Close a box
  Future<void> closeBox(String boxName) async {
    if (isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
      log.debug('Closed Hive box: $boxName');
    }
  }

  /// Delete a box (removes all data)
  Future<void> deleteBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
    log.debug('Deleted Hive box: $boxName');
  }

  /// Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
    log.info('All Hive boxes closed');
  }

  /// Register a Hive adapter
  /// Use this for custom objects
  void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
      log.debug('Registered Hive adapter: ${adapter.runtimeType}');
    }
  }
}

/// Global Hive service instance
final hiveService = HiveService();

/// Common box names - add your own as needed
class HiveBoxes {
  static const String settings = 'settings';
  static const String cache = 'cache';
  static const String user = 'user';
  static const String purchases = 'purchases'; // In-App Purchase data
  static const String entitlements = 'entitlements'; // User entitlements
  static const String searchCache = 'search_cache'; // TMDB search results
  static const String availabilityCache = 'availability_cache'; // Watch providers
  static const String detailsCache = 'details_cache'; // Movie/TV details
}

/// Cache extensions for TMDB data
extension TmdbCache on HiveService {
  static const int _cacheExpiryHours = 48; // Cache expires after 48 hours

  /// Cache search results
  Future<void> cacheSearchResults(String query, String jsonData) async {
    try {
      final box = await openBox<Map>(HiveBoxes.searchCache);
      await box.put(query.toLowerCase(), {
        'data': jsonData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      log.debug('Cached search results for: $query');
    } catch (e) {
      log.error('Failed to cache search results', e);
    }
  }

  /// Get cached search results (returns null if expired or not found)
  Future<String?> getCachedSearchResults(String query) async {
    try {
      final box = await openBox<Map>(HiveBoxes.searchCache);
      final data = box.get(query.toLowerCase());

      if (data == null) return null;

      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageInHours = (now - timestamp) / (1000 * 60 * 60);

      // Cache expired (older than 48 hours)
      if (ageInHours > _cacheExpiryHours) {
        await box.delete(query.toLowerCase());
        log.debug('Search cache expired for: $query (${ageInHours.toStringAsFixed(1)}h old)');
        return null;
      }

      log.debug('Using cached search results for: $query (${ageInHours.toStringAsFixed(1)}h old)');
      return data['data'] as String;
    } catch (e) {
      log.error('Failed to get cached search results', e);
      return null;
    }
  }

  /// Cache watch providers (availability)
  Future<void> cacheWatchProviders({
    required int movieId,
    required String mediaType,
    required String region,
    required String jsonData,
  }) async {
    try {
      final box = await openBox<Map>(HiveBoxes.availabilityCache);
      final key = '${movieId}_${mediaType}_$region';
      await box.put(key, {
        'data': jsonData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      log.debug('Cached availability for: $key');
    } catch (e) {
      log.error('Failed to cache availability', e);
    }
  }

  /// Get cached watch providers (returns null if expired or not found)
  Future<String?> getCachedWatchProviders({
    required int movieId,
    required String mediaType,
    required String region,
  }) async {
    try {
      final box = await openBox<Map>(HiveBoxes.availabilityCache);
      final key = '${movieId}_${mediaType}_$region';
      final data = box.get(key);

      if (data == null) return null;

      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageInHours = (now - timestamp) / (1000 * 60 * 60);

      // Cache expired (older than 48 hours)
      if (ageInHours > _cacheExpiryHours) {
        await box.delete(key);
        log.debug('Availability cache expired for: $key (${ageInHours.toStringAsFixed(1)}h old)');
        return null;
      }

      log.debug('Using cached availability for: $key (${ageInHours.toStringAsFixed(1)}h old)');
      return data['data'] as String;
    } catch (e) {
      log.error('Failed to get cached availability', e);
      return null;
    }
  }

  /// Cache movie/TV details
  Future<void> cacheDetails({
    required int movieId,
    required String mediaType,
    required String jsonData,
  }) async {
    try {
      final box = await openBox<Map>(HiveBoxes.detailsCache);
      final key = '${movieId}_$mediaType';
      await box.put(key, {
        'data': jsonData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      log.debug('Cached details for: $key');
    } catch (e) {
      log.error('Failed to cache details', e);
    }
  }

  /// Get cached movie/TV details (returns null if expired or not found)
  Future<String?> getCachedDetails({
    required int movieId,
    required String mediaType,
  }) async {
    try {
      final box = await openBox<Map>(HiveBoxes.detailsCache);
      final key = '${movieId}_$mediaType';
      final data = box.get(key);

      if (data == null) return null;

      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      final ageInHours = (now - timestamp) / (1000 * 60 * 60);

      // Cache expired (older than 48 hours)
      if (ageInHours > _cacheExpiryHours) {
        await box.delete(key);
        log.debug('Details cache expired for: $key (${ageInHours.toStringAsFixed(1)}h old)');
        return null;
      }

      log.debug('Using cached details for: $key (${ageInHours.toStringAsFixed(1)}h old)');
      return data['data'] as String;
    } catch (e) {
      log.error('Failed to get cached details', e);
      return null;
    }
  }

  /// Clear all TMDB caches
  Future<void> clearTmdbCache() async {
    try {
      await deleteBox(HiveBoxes.searchCache);
      await deleteBox(HiveBoxes.availabilityCache);
      await deleteBox(HiveBoxes.detailsCache);
      log.info('Cleared all TMDB caches');
    } catch (e) {
      log.error('Failed to clear TMDB cache', e);
    }
  }
}
