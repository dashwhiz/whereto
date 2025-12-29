/// Maps streaming provider IDs to local asset paths
/// This ensures crispy, high-quality logos without network requests
class ProviderLogoMapper {
  static const Map<int, String> _providerLogos = {
    // Major Streaming Services
    8: 'assets/images/providers/netflix.jpg', // Netflix
    9: 'assets/images/providers/amazon_prime.jpg', // Amazon Prime Video
    10: 'assets/images/providers/amazon_prime.jpg', // Amazon Video (rent/buy)
    337: 'assets/images/providers/disney_plus.jpg', // Disney Plus
    15: 'assets/images/providers/hulu.jpg', // Hulu
    531: 'assets/images/providers/paramount_plus.jpg', // Paramount+
    384: 'assets/images/providers/hbo_max.jpg', // HBO Max (legacy)
    1899: 'assets/images/providers/max.jpg', // Max (new HBO Max)
    386: 'assets/images/providers/peacock.jpg', // Peacock
    350: 'assets/images/providers/apple_tv_plus.jpg', // Apple TV+
    619: 'assets/images/providers/espn_plus.jpg', // ESPN+
    520: 'assets/images/providers/discovery_plus.jpg', // Discovery+
    // Rent/Buy Platforms
    2: 'assets/images/providers/apple_tv.jpg', // Apple TV (rent/buy)
    3: 'assets/images/providers/google_play.jpg', // Google Play Movies
    7: 'assets/images/providers/vudu.jpg', // Vudu
    68: 'assets/images/providers/microsoft_store.jpg', // Microsoft Store
    389: 'assets/images/providers/fandango_at_home.jpg', // Fandango at Home
    // Premium Channels
    37: 'assets/images/providers/showtime.jpg', // Showtime
    43: 'assets/images/providers/starz.jpg', // Starz
    528: 'assets/images/providers/amc_plus.jpg', // AMC+
    // Specialty Streaming
    283: 'assets/images/providers/crunchyroll.jpg', // Crunchyroll
    259: 'assets/images/providers/criterion_channel.jpg', // Criterion Channel
    99: 'assets/images/providers/shudder.jpg', // Shudder
    151: 'assets/images/providers/britbox.jpg', // BritBox
    11: 'assets/images/providers/mubi.jpg', // MUBI
    // Free Streaming
    73: 'assets/images/providers/tubi_tv.jpg', // Tubi TV
    300: 'assets/images/providers/pluto_tv.jpg', // Pluto TV
    188: 'assets/images/providers/youtube_premium.jpg', // YouTube Premium
    // Regional Services
    39: 'assets/images/providers/now_tv.jpg', // NOW TV (UK)
    29: 'assets/images/providers/sky_go.jpg', // Sky Go (UK)
  };

  /// Get local asset path for a provider ID
  /// Returns null if provider ID is not mapped to a local asset
  static String? getLocalLogoPath(int providerId) {
    return _providerLogos[providerId];
  }

  /// Check if a provider has a local logo
  static bool hasLocalLogo(int providerId) {
    return _providerLogos.containsKey(providerId);
  }

  /// Get all provider IDs with local logos
  static List<int> get availableProviderIds => _providerLogos.keys.toList();
}
