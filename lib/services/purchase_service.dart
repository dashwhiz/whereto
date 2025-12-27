import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../app/environments.dart';
import '../models/product_offering.dart';
import '../models/purchase.dart';
import '../repositories/purchase_repository.dart';
import 'logging_service.dart';

/// Purchase Service - Native In-App Purchase Implementation
///
/// Handles all in-app purchase operations using the official in_app_purchase plugin.
/// Supports both iOS (StoreKit) and Android (Google Play Billing).
///
/// Features:
/// - Query products from stores
/// - Purchase products (one-time and subscriptions)
/// - Restore purchases (device changes)
/// - Local caching for offline access
/// - Automatic purchase completion
///
/// Usage:
/// ```dart
/// // Initialize in main
/// await purchaseService.init();
///
/// // Load products
/// final products = await purchaseService.loadProducts();
///
/// // Purchase a product
/// await purchaseService.purchaseProduct('premium_unlock');
///
/// // Restore purchases
/// await purchaseService.restorePurchases();
/// ```
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Available products loaded from the store
  final List<ProductOffering> _availableProducts = [];
  List<ProductOffering> get availableProducts =>
      List.unmodifiable(_availableProducts);

  /// Initialize the purchase service
  ///
  /// Call this once in your app's main() or environment initialization
  Future<void> init() async {
    log.info('Initializing In-App Purchase service...');

    // Check if IAP is available on this device
    final available = await _iap.isAvailable();
    if (!available) {
      log.warning('⚠️ In-App Purchase not available on this device');
      return;
    }

    log.info('✅ In-App Purchase is available');

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        log.error('Purchase stream error', error);
      },
      onDone: () {
        log.info('Purchase stream closed');
      },
    );

    log.info('✅ Purchase service initialized');
  }

  /// Load products from the store
  ///
  /// Uses product IDs from the current environment configuration
  Future<List<ProductOffering>> loadProducts() async {
    try {
      log.info('Loading products from store...');

      // Get product IDs from environment
      final productIds = <String>{
        ...Environment.instance.iapProductIds,
        ...Environment.instance.subscriptionProductIds,
      };

      if (productIds.isEmpty) {
        log.warning('⚠️ No product IDs configured in environment');
        return [];
      }

      log.debug('Product IDs to query: $productIds');

      // Query products from store
      final response = await _iap.queryProductDetails(productIds);

      if (response.error != null) {
        log.error('Error loading products: ${response.error}');
        return [];
      }

      if (response.notFoundIDs.isNotEmpty) {
        log.warning('Products not found in store: ${response.notFoundIDs}');
      }

      // Convert to ProductOffering models
      _availableProducts.clear();
      for (var productDetails in response.productDetails) {
        _availableProducts.add(_convertToProductOffering(productDetails));
      }

      log.info('✅ Loaded ${_availableProducts.length} products');
      return availableProducts;
    } catch (e) {
      log.error('Error loading products', e);
      return [];
    }
  }

  /// Purchase a product
  ///
  /// Returns true if purchase was successful, false otherwise
  Future<bool> purchaseProduct(String productId) async {
    try {
      log.info('Starting purchase for product: $productId');

      // Load product details from store
      final response = await _iap.queryProductDetails({productId});
      if (response.productDetails.isEmpty) {
        log.error('Product not found in store: $productId');
        return false;
      }

      final productDetails = response.productDetails.first;

      // Create purchase param
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      // Start purchase flow (same method for both one-time and subscriptions)
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      if (!success) {
        log.error('Failed to initiate purchase');
        return false;
      }

      log.info('Purchase flow initiated');
      return true;
    } catch (e) {
      log.error('Error purchasing product: $productId', e);
      return false;
    }
  }

  /// Restore purchases
  ///
  /// This is THE KEY METHOD for handling device changes!
  /// It retrieves all purchases tied to the user's App Store/Google Play account.
  ///
  /// Returns true if any purchases were restored, false otherwise
  Future<bool> restorePurchases() async {
    try {
      log.info('Restoring purchases...');

      // Restore purchases from the store
      await _iap.restorePurchases();

      // The restored purchases will come through the purchase stream
      // which will trigger _onPurchaseUpdate()
      log.info('✅ Restore purchases initiated');

      // Check if we have any purchases cached locally
      final purchases = await purchaseRepository.getAllPurchases();
      final hasRestoredPurchases = purchases.isNotEmpty;

      if (hasRestoredPurchases) {
        log.info('✅ Found ${purchases.length} restored purchases');
      } else {
        log.info('No purchases to restore');
      }

      return hasRestoredPurchases;
    } catch (e) {
      log.error('Error restoring purchases', e);
      return false;
    }
  }

  /// Handle purchase updates from the stream
  ///
  /// This is called whenever a purchase is made, restored, or updated
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      log.debug('Purchase update: ${purchaseDetails.status}');

      // Handle different purchase states
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          log.info('Purchase pending: ${purchaseDetails.productID}');
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          log.info('✅ Purchase successful: ${purchaseDetails.productID}');
          await _handleSuccessfulPurchase(purchaseDetails);
          break;

        case PurchaseStatus.error:
          log.error('❌ Purchase error: ${purchaseDetails.error}');
          break;

        case PurchaseStatus.canceled:
          log.info('Purchase canceled: ${purchaseDetails.productID}');
          break;
      }

      // IMPORTANT: Complete the purchase
      // This tells the store we've delivered the content
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
        log.debug('Completed purchase: ${purchaseDetails.productID}');
      }
    }
  }

  /// Handle a successful purchase
  ///
  /// Save to local storage for offline access
  ///
  /// ⚠️ SECURITY: Currently using CLIENT-SIDE ONLY verification
  /// This is vulnerable to tampering! Users can modify Hive data to grant themselves purchases.
  ///
  /// TODO: Implement server-side verification for production:
  /// 1. Create a backend endpoint (e.g., Firebase Functions, your own API)
  /// 2. Send verificationData to your backend
  /// 3. Backend verifies receipt with Apple/Google servers:
  ///    - iOS: https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
  ///    - Android: https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get
  /// 4. Backend returns validation result
  /// 5. Only then set isVerified: true
  /// 6. Store backend verification token/timestamp
  ///
  /// Example backend verification flow:
  /// ```dart
  /// final verificationResult = await _verifyPurchaseWithBackend(details);
  /// if (verificationResult.isValid) {
  ///   purchase = purchase.copyWith(
  ///     isVerified: true,
  ///     backendVerificationToken: verificationResult.token,
  ///   );
  /// }
  /// ```
  ///
  /// Until backend is implemented: purchases are marked unverified by default.
  /// Consider adding Hive encryption (see hive_service.dart) as a temporary security measure.
  Future<void> _handleSuccessfulPurchase(PurchaseDetails details) async {
    try {
      // Check if this is a subscription product
      final isSubscription = Environment.instance.subscriptionProductIds
          .contains(details.productID);

      // Calculate expiration date for subscriptions
      // ⚠️ This is a TEMPORARY client-side estimate. For production:
      // - Backend should parse receipt/token and return actual expiration
      // - Use store-provided expiration date from receipt validation
      // - Handle grace periods, billing retry, and subscription renewal
      DateTime? expirationDate;
      if (isSubscription) {
        expirationDate = _estimateExpirationDate(details.productID);
      }

      // Create purchase model (unverified until backend validation)
      final purchase = Purchase(
        productId: details.productID,
        purchaseId: details.purchaseID ?? '',
        purchaseDate: DateTime.now(),
        verificationData: details.verificationData.serverVerificationData,
        isVerified:
            false, // ⚠️ Unverified - implement backend verification for production
        isActive: true, // Active locally, but should sync with backend
        isSubscription: isSubscription,
        expirationDate: expirationDate,
      );

      // Save to local storage
      await purchaseRepository.savePurchase(purchase);

      log.info('✅ Purchase saved locally (unverified): ${details.productID}');
      log.warning(
        '⚠️ Purchase needs server-side verification for production use',
      );

      // TODO: Implement backend verification
      // Uncomment when backend is ready:
      // final verified = await _verifyPurchaseWithBackend(details);
      // if (verified) {
      //   await purchaseRepository.updatePurchaseVerification(
      //     details.productID,
      //     isVerified: true,
      //   );
      // }
    } catch (e) {
      log.error('Error handling successful purchase', e);
    }
  }

  /// Estimate expiration date based on product ID
  ///
  /// ⚠️ TEMPORARY CLIENT-SIDE LOGIC - Replace with backend verification!
  /// This is a simple heuristic that looks at product ID keywords.
  /// In production, the backend should parse receipts and return actual expiration.
  DateTime _estimateExpirationDate(String productId) {
    final now = DateTime.now();
    final lowerCaseId = productId.toLowerCase();

    // Estimate based on product ID keywords
    if (lowerCaseId.contains('yearly') || lowerCaseId.contains('annual')) {
      return now.add(const Duration(days: 365));
    } else if (lowerCaseId.contains('monthly')) {
      return now.add(const Duration(days: 30));
    } else if (lowerCaseId.contains('weekly')) {
      return now.add(const Duration(days: 7));
    }

    // Default to monthly if unclear
    log.warning('⚠️ Could not determine subscription period for $productId, defaulting to 30 days');
    return now.add(const Duration(days: 30));
  }

  /// Convert ProductDetails to ProductOffering
  ProductOffering _convertToProductOffering(ProductDetails details) {
    return ProductOffering(
      id: details.id,
      title: details.title,
      description: details.description,
      price: details.price,
      rawPrice: details.rawPrice,
      currencyCode: details.currencyCode,
      isSubscription: Environment.instance.subscriptionProductIds.contains(
        details.id,
      ),
    );
  }

  /// Dispose the service
  ///
  /// Call this when the app is closing (usually not needed)
  void dispose() {
    _subscription?.cancel();
    log.info('Purchase service disposed');
  }
}

/// Global purchase service instance
final purchaseService = PurchaseService();
