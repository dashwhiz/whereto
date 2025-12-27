import 'package:logger/logger.dart';

/// Centralized logging service for the application
/// Use this for debugging API calls, errors, and general app flow
class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  late final Logger _logger;

  /// Initialize the logging service
  /// Call this in main() before runApp()
  void init({Level level = Level.debug}) {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: level,
    );
  }

  /// Log debug message (development only)
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error message
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log API request
  void apiRequest(String method, String url, {Map<String, dynamic>? body}) {
    info('🌐 API Request: $method $url${body != null ? '\nBody: $body' : ''}');
  }

  /// Log API response
  void apiResponse(String url, int statusCode, {dynamic body}) {
    if (statusCode >= 200 && statusCode < 300) {
      info('✅ API Response: $statusCode $url${body != null ? '\nBody: $body' : ''}');
    } else {
      error('❌ API Error: $statusCode $url${body != null ? '\nBody: $body' : ''}');
    }
  }

  /// Log navigation
  void navigation(String from, String to) {
    debug('🧭 Navigation: $from → $to');
  }
}

/// Global logger instance for easy access
final log = LoggingService();
