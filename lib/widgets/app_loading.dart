import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../app/app_colors.dart';

/// Unified loading widget using flutter_spinkit
///
/// To change the animation type, modify the widget in the build method.
/// Available animations: SpinKitWave, SpinKitCircle, SpinKitFadingCircle,
/// SpinKitRotatingCircle, SpinKitPulse, SpinKitDoubleBounce, SpinKitThreeBounce
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message});

  final String? message;
  static bool _isShowing = false;

  /// Show loading as a dialog overlay
  static void show(BuildContext context, {String? message}) {
    if (_isShowing) return;

    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => PopScope(
        canPop: false,
        child: AppLoading(message: message),
      ),
    );
  }

  /// Hide the loading dialog
  static void hide(BuildContext context) {
    if (!_isShowing) return;

    _isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Wrap an async operation with loading dialog
  static Future<T?> wrap<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? message,
  }) async {
    show(context, message: message);
    try {
      return await operation();
    } finally {
      hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Change SpinKitWave to any other SpinKit widget to customize animation
          SpinKitWave(
            color: AppColors.primary,
            size: 60.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
