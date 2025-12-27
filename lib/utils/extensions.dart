import 'date_utils.dart' as date_utils;

/// DateTime extensions for convenient date operations
extension DateTimeExtensions on DateTime {
  /// Add years to current date
  DateTime addYears(int years) => DateTime(
        year + years,
        month,
        day,
        hour,
        minute,
        second,
      );

  /// Add months to current date
  DateTime addMonths(int months) => DateTime(
        year,
        month + months,
        day,
        hour,
        minute,
        second,
      );

  /// Add days to current date
  DateTime addDays(int days) => DateTime(
        year,
        month,
        day + days,
        hour,
        minute,
        second,
      );

  /// Check if date is today
  bool get isToday => date_utils.isToday(this);

  /// Check if date is in the past
  bool get isPast => date_utils.isPast(this);

  /// Check if date is in the future
  bool get isFuture => date_utils.isFuture(this);

  /// Get start of day (midnight)
  DateTime get startOfDay => date_utils.startOfDay(this);

  /// Get end of day (23:59:59.999)
  DateTime get endOfDay => date_utils.endOfDay(this);

  /// Format as dd/MM/yyyy
  String get formatDdMmYyyy => date_utils.formatDdMmYyyy(this);

  /// Format as yyyy-MM-dd
  String get formatYyyyMmDd => date_utils.formatYyyyMmDd(this);

  /// Format as MMMM d, yyyy
  String get formatMmmDYyyy => date_utils.formatMmmDYyyy(this);

  /// Format as HH:mm
  String get formatHhMm => date_utils.formatHhMm(this);

  /// Format as hh:mm a
  String get formatHhMmA => date_utils.formatHhMmA(this);
}

/// String extensions for common operations
extension StringExtensions on String {
  /// Check if string is empty or null
  bool get isNullOrEmpty => isEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Parse string to date
  DateTime? get toDate => date_utils.parseDate(this);
}

/// Nullable string extensions
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Get value or default
  String orDefault(String defaultValue) => this ?? defaultValue;
}
