import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/app_colors.dart';
import '../../app/app_controller.dart';
import '../../app/app_error_listeners.dart';
import '../../app/app_progress_listeners.dart';
import '../../models/product_offering.dart';
import '../../services/purchase_service.dart';
import '../../services/entitlement_service.dart';
import '../../utils/operation_scope.dart';
import '../../widgets/app_loading.dart';

// =============================================================================
// CONTROLLER
// =============================================================================

/// Paywall controller - manages product loading and purchases
class PaywallController extends AppController {
  late final ProgressListener _progressListener;
  late final ErrorListener _errorListener;

  // Observable state
  final products = <ProductOffering>[].obs;
  final isRestoring = false.obs;

  @override
  void onInit() {
    super.onInit();
    _progressListener = DefaultProgressListener(Get.context!);
    _errorListener = DefaultErrorListener();

    // Defer loading until after the build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  /// Load products from the store
  Future<void> _loadProducts() async {
    isLoading = true;

    final operation = await scope(
      scope: () => purchaseService.loadProducts(),
      progressListener: _progressListener,
      errorListener: _errorListener,
      logLabel: 'Load products',
    );

    if (operation.success) {
      products.value = operation.result!;

      if (operation.result!.isEmpty) {
        WarningNotification.show('No products available');
      }
    }

    isLoading = false;
  }

  /// Purchase a product
  Future<void> purchase(ProductOffering product) async {
    final operation = await scope(
      scope: () => purchaseService.purchaseProduct(product.id),
      progressListener: _progressListener,
      errorListener: _errorListener,
      logLabel: 'Purchase product ${product.id}',
    );

    if (operation.success && operation.result == true) {
      // Refresh entitlements
      await entitlementService.refresh();

      SuccessNotification.show('Purchase successful!');
      Get.back(); // Close paywall
    } else if (operation.success && operation.result == false) {
      WarningNotification.show('Purchase failed or was cancelled');
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    isRestoring.value = true;

    final operation = await scope(
      scope: () => purchaseService.restorePurchases(),
      progressListener: _progressListener,
      errorListener: _errorListener,
      logLabel: 'Restore purchases',
    );

    if (operation.success && operation.result == true) {
      await entitlementService.refresh();
      SuccessNotification.show('Purchases restored!');
      Get.back(); // Close paywall
    } else if (operation.success && operation.result == false) {
      InfoNotification.show('No purchases found to restore');
    }

    isRestoring.value = false;
  }
}

// =============================================================================
// SCREEN
// =============================================================================

/// Paywall screen - displays available products for purchase
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaywallController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade'),
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isRestoring.value ? null : controller.restorePurchases,
            child: controller.isRestoring.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Restore'),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const AppLoading();
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                const Text(
                  'No products available',
                  style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller._loadProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _ProductCard(
              product: product,
              onPurchase: () => controller.purchase(product),
            );
          },
        );
      }),
    );
  }
}

// =============================================================================
// WIDGETS
// =============================================================================

/// Product card widget
class _ProductCard extends StatelessWidget {
  final ProductOffering product;
  final VoidCallback onPurchase;

  const _ProductCard({
    required this.product,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product.price,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Subscription badge
            if (product.isSubscription) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.info,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Purchase button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPurchase,
                child: const Text('Purchase'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
