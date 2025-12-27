/// Represents a product available for purchase in the store
///
/// This is a simple wrapper around store products (iOS/Android)
/// that provides a unified interface for displaying products in the UI.
///
/// Note: This doesn't use JSON serialization as it's populated from
/// the in_app_purchase plugin's ProductDetails, not from a backend.
class ProductOffering {
  /// Product ID (e.g., "premium_unlock", "monthly_subscription")
  final String id;

  /// Display title from the store
  final String title;

  /// Display description from the store
  final String description;

  /// Formatted price string (e.g., "$4.99", "€9.99")
  final String price;

  /// Raw price as a number
  final double rawPrice;

  /// Currency code (e.g., "USD", "EUR")
  final String currencyCode;

  /// Whether this is a subscription product
  final bool isSubscription;

  /// Subscription period (e.g., "monthly", "yearly") - null for one-time purchases
  final String? subscriptionPeriod;

  ProductOffering({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
    this.isSubscription = false,
    this.subscriptionPeriod,
  });

  @override
  String toString() {
    return 'ProductOffering(id: $id, title: $title, price: $price, '
        'isSubscription: $isSubscription)';
  }
}
