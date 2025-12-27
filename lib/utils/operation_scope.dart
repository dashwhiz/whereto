import 'dart:io';
import 'package:flutter/foundation.dart';
import '../app/app_error_listeners.dart';
import '../app/app_progress_listeners.dart';
import '../services/logging_service.dart';
import '../services/connectivity_service.dart';

/// Wrapper for generic operation results
class Operation<R> {
  const Operation({required this.success, this.result, this.exception});

  final bool success;
  final Object? exception;
  final R? result;
}

/// Exception type for error listener integration
class ErrorListenerException implements Exception {
  ErrorListenerException(this.code, this.errorMessage, this.headers);

  final int code;
  final String? errorMessage;
  final Map<String, String>? headers;
}

/// Wraps async operations with progress indication and error handling
///
/// **Offline-First Design:** Operations work offline by default.
/// Only set `requireConnectivity: true` for operations that genuinely need internet:
/// - HTTP API calls to backend servers
/// - Firebase real-time sync operations
/// - Remote data fetching
///
/// Local operations (IAP, Hive, cached data) work offline automatically.
///
/// Usage:
/// ```dart
/// // Local operation (works offline)
/// final operation = await scope(
///   scope: () => purchaseService.loadProducts(),
///   progressListener: _progressListener,
///   errorListener: _errorListener,
/// );
///
/// // Remote API call (requires internet)
/// final operation = await scope(
///   scope: () => repository.fetchDataFromAPI(),
///   progressListener: _progressListener,
///   errorListener: _errorListener,
///   requireConnectivity: true,  // Check connectivity first
/// );
///
/// if (operation.success) {
///   // Handle success
///   final data = operation.result;
/// }
/// ```
Future<Operation<R>> scope<R>({
  required Future<R> Function() scope,
  ProgressListener? progressListener,
  ErrorListener? errorListener,
  bool awaitForErrorListener = true,
  String? logLabel,
  bool requireConnectivity = false,  // Offline-first: connectivity check is opt-in
}) async {
  Operation<R> result;
  try {
    // Optional connectivity check (only when explicitly required)
    if (requireConnectivity) {
      final isConnected = await connectivityService.checkConnectivity();
      if (!isConnected) {
        throw NoConnectionException();
      }
    }

    if (logLabel != null) {
      log.debug('🔄 Starting operation: $logLabel');
    }
    progressListener?.show();
    result = Operation(success: true, result: await scope());
    progressListener?.hide();
    if (logLabel != null) {
      log.debug('✅ Operation completed: $logLabel');
    }
  } catch (e, s) {
    if (logLabel != null) {
      log.error('❌ Operation failed: $logLabel', e, s);
    }
    debugPrintStack(stackTrace: s, label: e.toString());
    result = Operation(success: false, exception: e, result: null);
    progressListener?.hide();

    // Extract error details
    int code = ErrorListener.unknownErrorCode;
    String? message;
    Map<String, String>? headers;

    if (e is ErrorListenerException) {
      code = e.code;
      message = e.errorMessage;
      headers = e.headers;
    } else if (e is NoConnectionException) {
      code = ErrorListener.offlineStatusCode;
      // Message will be translated by ErrorListener using 'noInternetConnection' key
    } else if (e is SocketException) {
      code = ErrorListener.timeOutStatusCode;
    }

    // Notify error listener
    if (errorListener != null) {
      if (awaitForErrorListener) {
        await errorListener.error(
          code: code,
          message: message,
          headers: headers,
        );
      } else {
        errorListener.error(code: code, message: message, headers: headers);
      }
    }
  }
  return result;
}
