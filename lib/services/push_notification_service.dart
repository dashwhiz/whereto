import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'hive_service.dart';
import 'logging_service.dart';
import '../app/app_error_listeners.dart';

/// Push Notification Service
///
/// Handles Firebase Cloud Messaging (FCM) for push notifications
/// Singleton pattern matching other services in the app
///
/// Features:
/// - Request notification permissions (iOS/Android)
/// - Get and store FCM tokens
/// - Handle foreground notifications (show snackbar)
/// - Handle background notification taps (navigation)
/// - Token refresh handling
///
/// Usage:
/// ```dart
/// // Initialize in main
/// await pushNotificationService.init();
///
/// // Get FCM token
/// final token = await pushNotificationService.getToken();
/// ```
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  FirebaseMessaging? _fcm;

  static const String _fcmTokenKey = 'fcm_token';

  /// Check if Firebase is initialized
  bool get isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get FCM instance (lazy initialization)
  FirebaseMessaging get fcm {
    if (_fcm == null) {
      if (!isFirebaseInitialized) {
        throw Exception('Firebase not initialized. Please call Firebase.initializeApp() first.');
      }
      _fcm = FirebaseMessaging.instance;
    }
    return _fcm!;
  }

  /// Initialize push notifications
  ///
  /// Call this once in your app's main() function after Firebase.initializeApp()
  Future<void> init() async {
    log.info('Initializing push notifications...');

    // Request permission (iOS)
    final settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log.info('✅ Push notification permission granted');

      // Get and save FCM token
      final token = await fcm.getToken();
      if (token != null) {
        await _saveToken(token);
        log.info('FCM Token: $token');

        // TODO: Send token to your backend if needed
        // await _sendTokenToBackend(token);
      }

      // Listen to token refresh
      fcm.onTokenRefresh.listen(
        (newToken) {
          log.info('FCM Token refreshed');
          try {
            _saveToken(newToken);
            // TODO: Send new token to your backend
          } catch (e, s) {
            log.error('Failed to save refreshed FCM token', e, s);
          }
        },
        onError: (error) {
          log.error('FCM token refresh error', error);
        },
      );

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
        onError: (error) {
          log.error('Foreground message error', error);
        },
      );

      // Listen to background message taps
      FirebaseMessaging.onMessageOpenedApp.listen(
        _handleMessageTap,
        onError: (error) {
          log.error('Message tap handling error', error);
        },
      );

      // Check if app was opened from a terminated state by tapping notification
      final initialMessage = await fcm.getInitialMessage();
      if (initialMessage != null) {
        log.info('App opened from terminated state via notification');
        _handleMessageTap(initialMessage);
      }

    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log.warning('⚠️ Push notification permission denied');
    } else if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      log.warning('⚠️ Push notification permission not determined');
    }
  }

  /// Handle notification when app is in foreground
  ///
  /// Shows a snackbar with the notification content
  void _handleForegroundMessage(RemoteMessage message) {
    log.info('📬 Foreground notification received');
    log.debug('Title: ${message.notification?.title}');
    log.debug('Body: ${message.notification?.body}');
    log.debug('Data: ${message.data}');

    // Show snackbar
    if (message.notification != null) {
      final title = message.notification!.title ?? 'Notification';
      final body = message.notification!.body ?? '';
      InfoNotification.show('$title: $body');
    }

    // You can also handle data-only messages here
    if (message.data.isNotEmpty) {
      log.debug('Notification data: ${message.data}');
      // Handle custom data
      _handleNotificationData(message.data);
    }
  }

  /// Handle notification tap (background or terminated)
  ///
  /// Navigates to the appropriate screen based on notification data
  void _handleMessageTap(RemoteMessage message) {
    log.info('👆 Notification tapped');
    log.debug('Data: ${message.data}');

    // Navigate based on notification data
    if (message.data.containsKey('screen')) {
      final screen = message.data['screen'];
      log.info('Navigating to screen: $screen');

      // TODO: Implement your navigation logic here
      // Example:
      // if (screen == 'profile') {
      //   Get.toNamed(AppRoutes.profile);
      // } else if (screen == 'settings') {
      //   Get.toNamed(AppRoutes.settings);
      // }
    }

    // Handle other custom data
    _handleNotificationData(message.data);
  }

  /// Handle custom notification data
  void _handleNotificationData(Map<String, dynamic> data) {
    // Implement your custom data handling logic here
    // Example:
    // if (data.containsKey('user_id')) {
    //   final userId = data['user_id'];
    //   // Do something with userId
    // }
  }

  /// Get current FCM token
  ///
  /// Returns the token if available, null otherwise
  Future<String?> getToken() async {
    // Check if Firebase is initialized
    if (!isFirebaseInitialized) {
      log.warning('⚠️ Firebase not initialized. Cannot get FCM token.');
      log.info('💡 To enable push notifications, uncomment Firebase initialization in environments.dart');
      return null;
    }

    try {
      // Try to get fresh token from FCM
      final token = await fcm.getToken();
      if (token != null) {
        await _saveToken(token);
        return token;
      }

      // Fallback to cached token
      return await _getCachedToken();
    } catch (e) {
      log.error('Error getting FCM token', e);
      return _getCachedToken();
    }
  }

  /// Save FCM token to local storage
  Future<void> _saveToken(String token) async {
    try {
      final box = await hiveService.openBox<String>(HiveBoxes.settings);
      await box.put(_fcmTokenKey, token);
      log.debug('FCM token saved to Hive');
    } catch (e) {
      log.error('Error saving FCM token', e);
    }
  }

  /// Get cached FCM token from local storage
  Future<String?> _getCachedToken() async {
    try {
      final box = await hiveService.openBox<String>(HiveBoxes.settings);
      return box.get(_fcmTokenKey);
    } catch (e) {
      log.error('Error getting cached FCM token', e);
      return null;
    }
  }

  /// Subscribe to a topic
  ///
  /// Useful for sending notifications to groups of users
  /// Example: Subscribe all users to 'news' topic for announcements
  Future<void> subscribeToTopic(String topic) async {
    try {
      await fcm.subscribeToTopic(topic);
      log.info('✅ Subscribed to topic: $topic');
    } catch (e) {
      log.error('Error subscribing to topic: $topic', e);
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await fcm.unsubscribeFromTopic(topic);
      log.info('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      log.error('Error unsubscribing from topic: $topic', e);
    }
  }

  /// Delete FCM token
  ///
  /// Call this when user logs out or wants to disable notifications
  Future<void> deleteToken() async {
    try {
      await fcm.deleteToken();
      final box = await hiveService.openBox<String>(HiveBoxes.settings);
      await box.delete(_fcmTokenKey);
      log.info('✅ FCM token deleted');
    } catch (e) {
      log.error('Error deleting FCM token', e);
    }
  }
}

/// Global push notification service instance
final pushNotificationService = PushNotificationService();

/// Background message handler (must be top-level function)
///
/// This function is called when a notification is received while the app
/// is in the background or terminated.
///
/// IMPORTANT: This must be a top-level function, not a class method.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if needed
  // await Firebase.initializeApp();

  log.info('📬 Background notification received');
  log.debug('Title: ${message.notification?.title}');
  log.debug('Body: ${message.notification?.body}');
  log.debug('Data: ${message.data}');

  // You can handle background data processing here
  // But avoid UI operations - they won't work in background
}
