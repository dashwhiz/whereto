import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/region.dart';
import 'logging_service.dart';
import 'hive_service.dart';

/// Service for detecting user's region from device location
/// Handles permissions and falls back to manual selection if needed
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  static const String _regionCodeKey = 'region_code';

  /// Initialize location service and detect region
  /// Returns the detected or previously saved region
  Future<Region> init() async {
    log.info('🌍 Initializing location service...');

    // Try to detect region from location FIRST (don't rely on saved region on init)
    final detectedRegion = await _detectRegionFromLocation();
    if (detectedRegion != null) {
      log.info('✅ Detected region: ${detectedRegion.name}');
      await _saveRegion(detectedRegion);
      return detectedRegion;
    }

    // Check if we have a saved region (fallback)
    final savedRegion = await _getSavedRegion();
    if (savedRegion != null) {
      log.info('📍 Using saved region: ${savedRegion.name}');
      return savedRegion;
    }

    // Fall back to default region (US) - but DON'T save it
    log.warning('⚠️ Could not detect location, using default region: ${Region.defaultRegion.name}');
    log.warning('💡 Tip: Grant location permission for automatic region detection');
    return Region.defaultRegion;
  }

  /// Detect region from device location
  Future<Region?> _detectRegionFromLocation() async {
    try {
      // Check location permission
      final permission = await _checkLocationPermission();
      if (!permission) {
        log.warning('📍 Location permission not granted');
        return null;
      }

      // Get current position
      log.info('📍 Getting device location...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      log.info('📍 Location: ${position.latitude}, ${position.longitude}');

      // Reverse geocode to get country
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        log.warning('📍 No placemarks found');
        return null;
      }

      final countryCode = placemarks.first.isoCountryCode;
      if (countryCode == null) {
        log.warning('📍 No country code found');
        return null;
      }

      log.info('📍 Detected country code: $countryCode');

      // Find region from country code
      final region = Region.findByCode(countryCode);
      if (region == null) {
        log.warning('📍 Region not supported: $countryCode');
        return null;
      }

      return region;
    } catch (e, s) {
      log.error('📍 Error detecting location', e, s);
      return null;
    }
  }

  /// Check and request location permission
  Future<bool> _checkLocationPermission() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log.warning('📍 Location services are disabled');
        return false;
      }

      // Check permission status
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          log.warning('📍 Location permission denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log.warning('📍 Location permission permanently denied');
        return false;
      }

      return true;
    } catch (e, s) {
      log.error('📍 Error checking permission', e, s);
      return false;
    }
  }

  /// Save region to local storage
  Future<void> _saveRegion(Region region) async {
    try {
      final box = await hiveService.openBox<String>(HiveBoxes.settings);
      await box.put(_regionCodeKey, region.code);
      log.info('💾 Saved region: ${region.code}');
    } catch (e, s) {
      log.error('💾 Error saving region', e, s);
    }
  }

  /// Get saved region from local storage
  Future<Region?> _getSavedRegion() async {
    try {
      final box = await hiveService.openBox<String>(HiveBoxes.settings);
      final regionCode = box.get(_regionCodeKey);

      if (regionCode == null) return null;

      return Region.findByCode(regionCode);
    } catch (e, s) {
      log.error('💾 Error loading saved region', e, s);
      return null;
    }
  }

  /// Manually set region (called from region selector)
  Future<void> setRegion(Region region) async {
    await _saveRegion(region);
    log.info('📍 Region manually set to: ${region.name}');
  }

  /// Get current region
  Future<Region> getCurrentRegion() async {
    final savedRegion = await _getSavedRegion();
    return savedRegion ?? Region.defaultRegion;
  }
}

/// Global instance
final locationService = LocationService();
