import 'package:get/get.dart';
import '../models/entitlement.dart';
import '../repositories/purchase_repository.dart';
import 'logging_service.dart';

/// Entitlement Service - Manages what the user has access to
///
/// This service tracks user entitlements (what they own) based on their purchases.
/// It provides observable properties that widgets can react to.
///
/// Features:
/// - Observable entitlements (GetX reactive)
/// - Check entitlements for specific products
/// - Automatic expiration checking for subscriptions
/// - Offline access via local cache
///
/// Usage:
/// ```dart
/// // Check if user has premium
/// if (entitlementService.hasPremium) {
///   // Show premium features
/// }
///
/// // In widgets
/// Obx(() => entitlementService.hasPremium
///   ? PremiumFeature()
///   : LockedFeature()
/// )
/// ```
class EntitlementService {
  static final EntitlementService _instance = EntitlementService._internal();
  factory EntitlementService() => _instance;
  EntitlementService._internal();

  // Observable entitlements - widgets can reactively listen to these
  final _hasPremium = false.obs;
  final _hasProFeatures = false.obs;

  /// Check if user has premium entitlement
  bool get hasPremium => _hasPremium.value;

  /// Check if user has pro features entitlement
  bool get hasProFeatures => _hasProFeatures.value;

  /// Initialize and check entitlements
  ///
  /// Call this after purchases are restored or on app start
  Future<void> checkEntitlements() async {
    try {
      log.info('Checking user entitlements...');

      // Clean up expired purchases and entitlements first
      await purchaseRepository.cleanupExpiredPurchases();
      await purchaseRepository.cleanupExpiredEntitlements();

      // Get all active purchases
      final purchases = await purchaseRepository.getAllPurchases();

      // Check for specific entitlements
      _hasPremium.value = purchases.any((p) =>
        p.isActive &&
        (p.productId.contains('premium') || p.productId.contains('unlock')) &&
        !p.isExpired
      );

      _hasProFeatures.value = purchases.any((p) =>
        p.isActive &&
        p.productId.contains('pro') &&
        !p.isExpired
      );

      log.info('Entitlements: Premium=$hasPremium, Pro=$hasProFeatures');

      // Update entitlement objects in repository
      await _updateEntitlementObjects(purchases);
    } catch (e) {
      log.error('Error checking entitlements', e);
    }
  }

  /// Update entitlement objects in the repository
  Future<void> _updateEntitlementObjects(List<dynamic> purchases) async {
    try {
      // Create/update premium entitlement
      if (_hasPremium.value) {
        final premiumPurchase = purchases.firstWhere(
          (p) => p.isActive && p.productId.contains('premium'),
        );

        final premiumEntitlement = Entitlement(
          identifier: 'premium',
          isActive: true,
          grantedDate: premiumPurchase.purchaseDate,
          productId: premiumPurchase.productId,
        );

        await purchaseRepository.saveEntitlement(premiumEntitlement);
      }

      // Create/update pro entitlement
      if (_hasProFeatures.value) {
        final proPurchase = purchases.firstWhere(
          (p) => p.isActive && p.productId.contains('pro'),
        );

        final proEntitlement = Entitlement(
          identifier: 'pro_features',
          isActive: true,
          grantedDate: proPurchase.purchaseDate,
          expirationDate: proPurchase.expirationDate,
          productId: proPurchase.productId,
        );

        await purchaseRepository.saveEntitlement(proEntitlement);
      }
    } catch (e) {
      log.error('Error updating entitlement objects', e);
    }
  }

  /// Check a specific entitlement by identifier
  ///
  /// This is a more flexible way to check for custom entitlements
  Future<bool> hasEntitlement(String identifier) async {
    try {
      final entitlement = await purchaseRepository.getEntitlement(identifier);
      if (entitlement == null) return false;

      return entitlement.isActive && !entitlement.isExpired;
    } catch (e) {
      log.error('Error checking entitlement: $identifier', e);
      return false;
    }
  }

  /// Get all active entitlements
  Future<List<Entitlement>> getActiveEntitlements() async {
    return await purchaseRepository.getActiveEntitlements();
  }

  /// Refresh entitlements
  ///
  /// Call this after a purchase or restore to update the UI
  Future<void> refresh() async {
    await checkEntitlements();
    log.info('Entitlements refreshed');
  }

  /// Clear all entitlements (for testing or logout)
  Future<void> clearAll() async {
    await purchaseRepository.clearAllEntitlements();
    _hasPremium.value = false;
    _hasProFeatures.value = false;
    log.info('All entitlements cleared');
  }
}

/// Global entitlement service instance
final entitlementService = EntitlementService();
