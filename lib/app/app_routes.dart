import 'package:get/get.dart';
import '../screens/search/search_screen.dart';

/// Centralized routing for the application
/// Use static methods for type-safe navigation
class AppRoutes {
  /// Navigate to search screen
  static Future<dynamic>? navigateToSearch() {
    return Get.to(() => const SearchScreen());
  }

  /// Navigate to search screen and remove all previous routes
  static Future<dynamic>? navigateToSearchAndClearStack() {
    return Get.offAll(() => const SearchScreen());
  }

  /// Navigate to search screen and remove previous route
  static Future<dynamic>? navigateToSearchAndReplaceCurrent() {
    return Get.off(() => const SearchScreen());
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
