/// Language option data model
class LanguageOption {
  const LanguageOption(
    this.displayName,
    this.languageCode,
    this.countryCode,
    this.flag,
  );

  final String displayName;
  final String languageCode;
  final String countryCode;
  final String flag;
}
