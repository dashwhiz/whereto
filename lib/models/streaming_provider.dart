/// Streaming service provider model
/// Represents a platform where content can be watched (Netflix, Prime, etc.)
class StreamingProvider {
  final int providerId;
  final String providerName;    // e.g., "Netflix", "Prime Video"
  final String logoPath;        // Provider logo path from TMDB
  final String type;            // "flatrate" (subscription), "rent", "buy"
  final String? price;          // Optional price for rent/buy

  const StreamingProvider({
    required this.providerId,
    required this.providerName,
    required this.logoPath,
    required this.type,
    this.price,
  });

  /// Get full logo URL for TMDB images
  /// Size options: w45, w92, w154, w185, w300, h60, original
  String getLogoUrl({String size = 'w92'}) {
    return 'https://image.tmdb.org/t/p/$size$logoPath';
  }

  /// Display text for provider type
  String get typeDisplay {
    switch (type) {
      case 'flatrate':
        return 'Stream';
      case 'rent':
        return 'Rent';
      case 'buy':
        return 'Buy';
      default:
        return type;
    }
  }

  /// Check if this provider requires payment
  bool get requiresPayment => type == 'rent' || type == 'buy';

  /// Check if this is a subscription service
  bool get isSubscription => type == 'flatrate';
}
