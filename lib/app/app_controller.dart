import 'package:get/get.dart';

/// Base controller for all GetX controllers
/// Provides common functionality and lifecycle management
abstract class AppController extends GetxController {
  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  /// Called when controller is initialized
  @override
  void onInit() {
    super.onInit();
    // Override in child classes for initialization logic
  }

  /// Called when controller is ready (after view is built)
  @override
  void onReady() {
    super.onReady();
    // Override in child classes for post-initialization logic
  }

  /// Called when controller is disposed
  @override
  void onClose() {
    super.onClose();
    // Override in child classes for cleanup
  }
}
