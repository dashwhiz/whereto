import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/entitlement_service.dart';
import '../screens/purchase/paywall_screen.dart';

/// Premium Feature Button
///
/// A reusable widget that checks if user has required entitlement
/// before executing an action. If not, shows the paywall.
///
/// Usage:
/// ```dart
/// PremiumFeatureButton(
///   onPressed: () {
///     // This only runs if user has premium
///     print('Premium feature executed');
///   },
///   icon: const Icon(Icons.star),
///   label: const Text('Premium Feature'),
/// )
/// ```
class PremiumFeatureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget label;
  final bool requiresPremium;
  final bool requiresPro;

  const PremiumFeatureButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.requiresPremium = true,
    this.requiresPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if user has required entitlement
      final hasAccess = _checkAccess();

      return ElevatedButton.icon(
        onPressed: () {
          if (hasAccess) {
            onPressed();
          } else {
            _showPaywall();
          }
        },
        icon: icon ?? const Icon(Icons.lock),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            label,
            if (!hasAccess) ...[
              const SizedBox(width: 8),
              const Icon(Icons.lock_outline, size: 16),
            ],
          ],
        ),
      );
    });
  }

  /// Check if user has access
  bool _checkAccess() {
    if (requiresPro) {
      return entitlementService.hasProFeatures;
    }
    if (requiresPremium) {
      return entitlementService.hasPremium;
    }
    return true;
  }

  /// Show paywall
  void _showPaywall() {
    Get.to(() => const PaywallScreen());
  }
}

/// Premium Feature Icon Button
///
/// Same as PremiumFeatureButton but in icon button style
class PremiumFeatureIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String? tooltip;
  final bool requiresPremium;
  final bool requiresPro;

  const PremiumFeatureIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.requiresPremium = true,
    this.requiresPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasAccess = _checkAccess();

      return IconButton(
        onPressed: () {
          if (hasAccess) {
            onPressed();
          } else {
            _showPaywall();
          }
        },
        icon: Stack(
          children: [
            icon,
            if (!hasAccess)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        tooltip: tooltip,
      );
    });
  }

  bool _checkAccess() {
    if (requiresPro) {
      return entitlementService.hasProFeatures;
    }
    if (requiresPremium) {
      return entitlementService.hasPremium;
    }
    return true;
  }

  void _showPaywall() {
    Get.to(() => const PaywallScreen());
  }
}
