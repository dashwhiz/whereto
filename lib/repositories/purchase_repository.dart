import '../models/purchase.dart';
import '../models/entitlement.dart';
import '../services/hive_service.dart';
import '../services/logging_service.dart';

/// Repository for managing purchase and entitlement data
///
/// Handles local storage of purchases and entitlements using Hive.
/// Provides data access layer between services and local storage.
class PurchaseRepository {
  static final PurchaseRepository _instance = PurchaseRepository._internal();
  factory PurchaseRepository() => _instance;
  PurchaseRepository._internal();

  // =========================================================================
  // PURCHASE METHODS
  // =========================================================================

  /// Save a purchase to local storage (encrypted)
  Future<void> savePurchase(Purchase purchase) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.purchases, encrypted: true);
      await box.put(purchase.productId, purchase.toJson());
      log.debug('Saved purchase (encrypted): ${purchase.productId}');
    } catch (e) {
      log.error('Error saving purchase', e);
    }
  }

  /// Get a purchase by product ID
  Future<Purchase?> getPurchase(String productId) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.purchases, encrypted: true);
      final data = box.get(productId);
      if (data != null && data is Map) {
        return Purchase.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      log.error('Error getting purchase: $productId', e);
      return null;
    }
  }

  /// Get all purchases
  Future<List<Purchase>> getAllPurchases() async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.purchases, encrypted: true);
      final purchases = <Purchase>[];

      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null && data is Map) {
          purchases.add(Purchase.fromJson(Map<String, dynamic>.from(data)));
        }
      }

      return purchases;
    } catch (e) {
      log.error('Error getting all purchases', e);
      return [];
    }
  }

  /// Delete a purchase
  Future<void> deletePurchase(String productId) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.purchases, encrypted: true);
      await box.delete(productId);
      log.debug('Deleted purchase: $productId');
    } catch (e) {
      log.error('Error deleting purchase: $productId', e);
    }
  }

  /// Clear all purchases
  Future<void> clearAllPurchases() async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.purchases, encrypted: true);
      await box.clear();
      log.info('Cleared all purchases');
    } catch (e) {
      log.error('Error clearing purchases', e);
    }
  }

  // =========================================================================
  // ENTITLEMENT METHODS
  // =========================================================================

  /// Save an entitlement to local storage (encrypted)
  Future<void> saveEntitlement(Entitlement entitlement) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.entitlements, encrypted: true);
      await box.put(entitlement.identifier, entitlement.toJson());
      log.debug('Saved entitlement (encrypted): ${entitlement.identifier}');
    } catch (e) {
      log.error('Error saving entitlement', e);
    }
  }

  /// Get an entitlement by identifier
  Future<Entitlement?> getEntitlement(String identifier) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.entitlements, encrypted: true);
      final data = box.get(identifier);
      if (data != null && data is Map) {
        return Entitlement.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      log.error('Error getting entitlement: $identifier', e);
      return null;
    }
  }

  /// Get all entitlements
  Future<List<Entitlement>> getAllEntitlements() async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.entitlements, encrypted: true);
      final entitlements = <Entitlement>[];

      for (var key in box.keys) {
        final data = box.get(key);
        if (data != null && data is Map) {
          entitlements.add(Entitlement.fromJson(Map<String, dynamic>.from(data)));
        }
      }

      return entitlements;
    } catch (e) {
      log.error('Error getting all entitlements', e);
      return [];
    }
  }

  /// Get all active entitlements (not expired)
  Future<List<Entitlement>> getActiveEntitlements() async {
    final allEntitlements = await getAllEntitlements();
    return allEntitlements.where((e) => e.isActive && !e.isExpired).toList();
  }

  /// Delete an entitlement
  Future<void> deleteEntitlement(String identifier) async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.entitlements, encrypted: true);
      await box.delete(identifier);
      log.debug('Deleted entitlement: $identifier');
    } catch (e) {
      log.error('Error deleting entitlement: $identifier', e);
    }
  }

  /// Clear all entitlements
  Future<void> clearAllEntitlements() async {
    try {
      final box = await hiveService.openBox<dynamic>(HiveBoxes.entitlements, encrypted: true);
      await box.clear();
      log.info('Cleared all entitlements');
    } catch (e) {
      log.error('Error clearing entitlements', e);
    }
  }

  // =========================================================================
  // UTILITY METHODS
  // =========================================================================

  /// Clean up expired subscriptions
  ///
  /// Marks expired subscription purchases as inactive
  /// This should be called periodically or on app start
  Future<void> cleanupExpiredPurchases() async {
    try {
      final purchases = await getAllPurchases();
      int expiredCount = 0;

      for (var purchase in purchases) {
        if (purchase.isSubscription && purchase.isExpired && purchase.isActive) {
          // Mark as inactive
          final updatedPurchase = purchase.copyWith(isActive: false);
          await savePurchase(updatedPurchase);
          expiredCount++;
          log.debug('Marked expired purchase as inactive: ${purchase.productId}');
        }
      }

      if (expiredCount > 0) {
        log.info('Cleaned up $expiredCount expired purchase(s)');
      }
    } catch (e) {
      log.error('Error cleaning up expired purchases', e);
    }
  }

  /// Clean up expired entitlements
  ///
  /// Marks expired entitlements as inactive
  Future<void> cleanupExpiredEntitlements() async {
    try {
      final entitlements = await getAllEntitlements();
      int expiredCount = 0;

      for (var entitlement in entitlements) {
        if (entitlement.isExpired && entitlement.isActive) {
          // Create updated entitlement marked as inactive
          final updatedEntitlement = Entitlement(
            identifier: entitlement.identifier,
            isActive: false,
            grantedDate: entitlement.grantedDate,
            expirationDate: entitlement.expirationDate,
            productId: entitlement.productId,
          );
          await saveEntitlement(updatedEntitlement);
          expiredCount++;
          log.debug('Marked expired entitlement as inactive: ${entitlement.identifier}');
        }
      }

      if (expiredCount > 0) {
        log.info('Cleaned up $expiredCount expired entitlement(s)');
      }
    } catch (e) {
      log.error('Error cleaning up expired entitlements', e);
    }
  }

  /// Clear all purchase-related data (for testing or logout)
  Future<void> clearAll() async {
    await clearAllPurchases();
    await clearAllEntitlements();
    log.info('Cleared all purchase and entitlement data');
  }
}

/// Global purchase repository instance
final purchaseRepository = PurchaseRepository();
