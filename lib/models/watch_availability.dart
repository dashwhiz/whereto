import 'streaming_provider.dart';

/// Watch availability data for a movie/show in a specific region
/// Contains all the streaming providers where the content can be watched
class WatchAvailability {
  final int movieId;
  final String countryCode;         // ISO 3166-1 alpha-2 country code (e.g., "US", "DE")
  final List<StreamingProvider> flatrate;  // Subscription services
  final List<StreamingProvider> rent;      // Rental options
  final List<StreamingProvider> buy;       // Purchase options
  final DateTime lastUpdated;

  const WatchAvailability({
    required this.movieId,
    required this.countryCode,
    this.flatrate = const [],
    this.rent = const [],
    this.buy = const [],
    required this.lastUpdated,
  });

  /// Check if content is available in any form in this region
  bool get isAvailable =>
      flatrate.isNotEmpty || rent.isNotEmpty || buy.isNotEmpty;

  /// Check if content is available for free streaming (subscription)
  bool get hasStreaming => flatrate.isNotEmpty;

  /// Check if content can be rented
  bool get hasRental => rent.isNotEmpty;

  /// Check if content can be purchased
  bool get hasPurchase => buy.isNotEmpty;

  /// Get all providers combined
  List<StreamingProvider> get allProviders {
    return [...flatrate, ...rent, ...buy];
  }

  /// Check if data is stale (older than 2 days)
  bool get isStale {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inDays >= 2;
  }
}
