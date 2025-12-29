/// Region/Country model for streaming availability
/// Represents a country where users can check streaming options
class Region {
  final String code;         // ISO 3166-1 alpha-2 country code (e.g., "US", "DE", "GB")
  final String name;         // Full country name (e.g., "United States")
  final String flag;         // Flag emoji (e.g., "🇺🇸")

  const Region({
    required this.code,
    required this.name,
    required this.flag,
  });

  /// Display format for UI: "🇺🇸 United States"
  String get displayName => '$flag $name';

  /// Popular regions that should be shown first in selectors
  static const List<Region> popular = [
    Region(code: 'US', name: 'United States', flag: '🇺🇸'),
    Region(code: 'GB', name: 'United Kingdom', flag: '🇬🇧'),
    Region(code: 'DE', name: 'Germany', flag: '🇩🇪'),
    Region(code: 'FR', name: 'France', flag: '🇫🇷'),
    Region(code: 'CA', name: 'Canada', flag: '🇨🇦'),
    Region(code: 'AU', name: 'Australia', flag: '🇦🇺'),
  ];

  /// All supported regions (alphabetically sorted)
  static const List<Region> all = [
    ...popular,
    Region(code: 'AR', name: 'Argentina', flag: '🇦🇷'),
    Region(code: 'AT', name: 'Austria', flag: '🇦🇹'),
    Region(code: 'BE', name: 'Belgium', flag: '🇧🇪'),
    Region(code: 'BR', name: 'Brazil', flag: '🇧🇷'),
    Region(code: 'CH', name: 'Switzerland', flag: '🇨🇭'),
    Region(code: 'CL', name: 'Chile', flag: '🇨🇱'),
    Region(code: 'CN', name: 'China', flag: '🇨🇳'),
    Region(code: 'CO', name: 'Colombia', flag: '🇨🇴'),
    Region(code: 'CZ', name: 'Czech Republic', flag: '🇨🇿'),
    Region(code: 'DK', name: 'Denmark', flag: '🇩🇰'),
    Region(code: 'ES', name: 'Spain', flag: '🇪🇸'),
    Region(code: 'FI', name: 'Finland', flag: '🇫🇮'),
    Region(code: 'GR', name: 'Greece', flag: '🇬🇷'),
    Region(code: 'HK', name: 'Hong Kong', flag: '🇭🇰'),
    Region(code: 'HU', name: 'Hungary', flag: '🇭🇺'),
    Region(code: 'ID', name: 'Indonesia', flag: '🇮🇩'),
    Region(code: 'IE', name: 'Ireland', flag: '🇮🇪'),
    Region(code: 'IL', name: 'Israel', flag: '🇮🇱'),
    Region(code: 'IN', name: 'India', flag: '🇮🇳'),
    Region(code: 'IT', name: 'Italy', flag: '🇮🇹'),
    Region(code: 'JP', name: 'Japan', flag: '🇯🇵'),
    Region(code: 'KR', name: 'South Korea', flag: '🇰🇷'),
    Region(code: 'MX', name: 'Mexico', flag: '🇲🇽'),
    Region(code: 'MY', name: 'Malaysia', flag: '🇲🇾'),
    Region(code: 'NL', name: 'Netherlands', flag: '🇳🇱'),
    Region(code: 'NO', name: 'Norway', flag: '🇳🇴'),
    Region(code: 'NZ', name: 'New Zealand', flag: '🇳🇿'),
    Region(code: 'PH', name: 'Philippines', flag: '🇵🇭'),
    Region(code: 'PL', name: 'Poland', flag: '🇵🇱'),
    Region(code: 'PT', name: 'Portugal', flag: '🇵🇹'),
    Region(code: 'RO', name: 'Romania', flag: '🇷🇴'),
    Region(code: 'RU', name: 'Russia', flag: '🇷🇺'),
    Region(code: 'SE', name: 'Sweden', flag: '🇸🇪'),
    Region(code: 'SG', name: 'Singapore', flag: '🇸🇬'),
    Region(code: 'TH', name: 'Thailand', flag: '🇹🇭'),
    Region(code: 'TR', name: 'Turkey', flag: '🇹🇷'),
    Region(code: 'TW', name: 'Taiwan', flag: '🇹🇼'),
    Region(code: 'ZA', name: 'South Africa', flag: '🇿🇦'),
  ];

  /// Find region by country code
  static Region? findByCode(String code) {
    try {
      return all.firstWhere(
        (region) => region.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Default region (United States)
  static const Region defaultRegion = Region(
    code: 'US',
    name: 'United States',
    flag: '🇺🇸',
  );
}
