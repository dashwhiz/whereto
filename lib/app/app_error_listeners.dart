import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import '../api/api_status_codes.dart';

/// Base error listener interface
abstract class ErrorListener {
  static const unknownErrorCode = -1;
  static const offlineStatusCode = -2;
  static const timeOutStatusCode = -3;

  Future<void> error({
    int? code,
    String? message,
    Map<String, String>? headers,
  });
}

/// Default error listener using GetX snackbar from top
class DefaultErrorListener extends ErrorListener {
  @override
  Future<void> error({
    int? code,
    String? message,
    Map<String, String>? headers,
  }) async {
    code ??= ErrorListener.unknownErrorCode;
    message ??= _getMessageFromCode(code);

    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      icon: const Icon(Icons.error_outline, color: AppColors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  String _getMessageFromCode(int code) {
    if (code == ErrorListener.offlineStatusCode) {
      return 'noInternetConnection'.tr;
    } else if (code == ErrorListener.timeOutStatusCode) {
      return 'connectionTimeout'.tr;
    } else if (code == ApiStatusCodes.unauthorized) {
      return 'unauthorized'.tr;
    } else if (code == ApiStatusCodes.notFound) {
      return 'notFound'.tr;
    } else if (code == ApiStatusCodes.serverError) {
      return 'serverError'.tr;
    }
    return 'unknownError'.tr;
  }
}

/// Success snackbar helper
class SuccessNotification {
  static void show(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

/// Warning snackbar helper
class WarningNotification {
  static void show(String message) {
    Get.snackbar(
      'warning'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning,
      colorText: AppColors.white,
      icon: const Icon(Icons.warning_amber_outlined, color: AppColors.white),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

/// Info snackbar helper
class InfoNotification {
  static void show(String message) {
    Get.snackbar(
      'info'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      icon: const Icon(Icons.info_outline, color: AppColors.white),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
