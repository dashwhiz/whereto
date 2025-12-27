import 'package:get/get.dart';
import '../screens/home/home_screen.dart';
import '../screens/purchase/paywall_screen.dart';

/// Centralized routing for the application
/// Use static methods for type-safe navigation
class AppRoutes {
  /// Navigate to home screen
  static Future<dynamic>? navigateToHome() {
    return Get.to(() => const HomeScreen());
  }

  /// Navigate to home screen and remove all previous routes
  static Future<dynamic>? navigateToHomeAndClearStack() {
    return Get.offAll(() => const HomeScreen());
  }

  /// Navigate to home screen and remove previous route
  static Future<dynamic>? navigateToHomeAndReplaceCurrent() {
    return Get.off(() => const HomeScreen());
  }

  /// Navigate to paywall screen
  static Future<dynamic>? navigateToPaywall() {
    return Get.to(() => const PaywallScreen());
  }

  /// Go back to previous screen
  static void goBack() {
    Get.back();
  }

  /// Go back with result
  static void goBackWithResult<T>(T result) {
    Get.back(result: result);
  }
}
