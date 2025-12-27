import 'package:json_annotation/json_annotation.dart';

part 'entitlement.g.dart';

/// Represents what features/content a user has access to
///
/// Entitlements are the result of purchases. For example:
/// - Purchase "premium_unlock" → grants "premium" entitlement
/// - Purchase "monthly_subscription" → grants "pro_features" entitlement
///
/// This model tracks active entitlements and their expiration dates.
@JsonSerializable()
class Entitlement {
  /// Unique identifier for this entitlement (e.g., "premium", "pro_features")
  final String identifier;

  /// Whether this entitlement is currently active
  final bool isActive;

  /// When this entitlement was first granted
  final DateTime grantedDate;

  /// When this entitlement will expire (null for lifetime purchases)
  final DateTime? expirationDate;

  /// Product ID that granted this entitlement
  final String? productId;

  Entitlement({
    required this.identifier,
    required this.isActive,
    required this.grantedDate,
    this.expirationDate,
    this.productId,
  });

  /// Check if this entitlement is expired
  bool get isExpired {
    if (expirationDate == null) return false; // Lifetime entitlement
    return DateTime.now().isAfter(expirationDate!);
  }

  /// Check if this is a lifetime entitlement (no expiration)
  bool get isLifetime => expirationDate == null;

  /// Check if this is a subscription (has expiration date)
  bool get isSubscription => expirationDate != null;

  /// Days remaining until expiration (null for lifetime)
  int? get daysRemaining {
    if (expirationDate == null) return null;
    return expirationDate!.difference(DateTime.now()).inDays;
  }

  // JSON serialization
  factory Entitlement.fromJson(Map<String, dynamic> json) =>
      _$EntitlementFromJson(json);

  Map<String, dynamic> toJson() => _$EntitlementToJson(this);

  @override
  String toString() {
    return 'Entitlement(identifier: $identifier, isActive: $isActive, '
        'isLifetime: $isLifetime, expirationDate: $expirationDate)';
  }
}
