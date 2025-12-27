import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'logging_service.dart';

/// Centralized connectivity service
/// Checks internet connectivity before making API calls
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Current connectivity status
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  /// Track if this is the initial check (to suppress noisy logs during startup)
  bool _isInitializing = true;

  /// Initialize connectivity monitoring
  /// Call this in main() before runApp()
  Future<void> init() async {
    log.info('Initializing connectivity service...');

    // Check initial connectivity (suppress logs during startup)
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result, logChanges: false);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        log.error('Connectivity monitoring error', error);
      },
    );

    // After a brief delay, enable logging and log the final status
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitializing = false;

    // Log the actual stable connection status
    if (_isConnected) {
      log.info('📶 Connected to internet');
    } else {
      log.warning('📵 No internet connection');
    }

    log.info('Connectivity service initialized');
  }

  /// Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> results, {bool logChanges = true}) {
    final wasConnected = _isConnected;
    _isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);

    // Only log if not initializing, logging is enabled, and status actually changed
    if (!_isInitializing && logChanges && wasConnected != _isConnected) {
      if (_isConnected) {
        log.info('📶 Connected to internet');
      } else {
        log.warning('📵 No internet connection');
      }
    }
  }

  /// Check if device has internet connectivity
  /// Returns true if connected, false otherwise
  /// Does not log status (to avoid noise on every API call)
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result, logChanges: false);
    return _isConnected;
  }

  /// Dispose connectivity subscription
  void dispose() {
    _subscription?.cancel();
    log.debug('Connectivity service disposed');
  }
}

/// Global connectivity service instance
final connectivityService = ConnectivityService();

/// Exception thrown when there's no internet connection
/// The user-facing message is handled by ErrorListener with translations
class NoConnectionException implements Exception {
  @override
  String toString() => 'NoConnectionException: Device offline';
}
