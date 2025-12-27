import 'package:json_annotation/json_annotation.dart';

part 'purchase.g.dart';

/// Represents a completed in-app purchase
///
/// This model stores purchase records locally for:
/// - Offline access to purchased features
/// - Purchase history tracking
/// - Receipt validation caching
@JsonSerializable()
class Purchase {
  /// Product ID that was purchased
  final String productId;

  /// Purchase ID / Transaction ID from the store
  final String purchaseId;

  /// When the purchase was made
  final DateTime purchaseDate;

  /// Purchase token (Android) or transaction receipt (iOS)
  final String? verificationData;

  /// Whether this purchase has been verified with the store
  final bool isVerified;

  /// Whether this purchase is a subscription
  final bool isSubscription;

  /// Subscription expiration date (null for one-time purchases)
  final DateTime? expirationDate;

  /// Whether the purchase is still valid/active
  final bool isActive;

  Purchase({
    required this.productId,
    required this.purchaseId,
    required this.purchaseDate,
    this.verificationData,
    this.isVerified = false,
    this.isSubscription = false,
    this.expirationDate,
    this.isActive = true,
  });

  /// Check if this purchase has expired (for subscriptions)
  bool get isExpired {
    if (!isSubscription) return false; // One-time purchases don't expire
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  /// Create a copy with updated fields
  Purchase copyWith({
    String? productId,
    String? purchaseId,
    DateTime? purchaseDate,
    String? verificationData,
    bool? isVerified,
    bool? isSubscription,
    DateTime? expirationDate,
    bool? isActive,
  }) {
    return Purchase(
      productId: productId ?? this.productId,
      purchaseId: purchaseId ?? this.purchaseId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      verificationData: verificationData ?? this.verificationData,
      isVerified: isVerified ?? this.isVerified,
      isSubscription: isSubscription ?? this.isSubscription,
      expirationDate: expirationDate ?? this.expirationDate,
      isActive: isActive ?? this.isActive,
    );
  }

  // JSON serialization
  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  @override
  String toString() {
    return 'Purchase(productId: $productId, purchaseId: $purchaseId, '
        'isActive: $isActive, isSubscription: $isSubscription, '
        'expirationDate: $expirationDate)';
  }
}
