import 'package:intl/intl.dart';

/// Common date format patterns
const String ddMmYyyy = 'dd/MM/yyyy';
const String ddMmYyyyDots = 'dd.MM.yyyy';
const String yyyyMmDd = 'yyyy-MM-dd';
const String yyyyMmDdHhMmSs = 'yyyy-MM-dd HH:mm:ss';
const String mmYyyy = 'MM/yyyy';
const String mmmYy = 'MMM yy';
const String ddMmm = 'dd MMM';
const String ddMmmDot = 'dd.MMM';
const String yyyy = 'yyyy';
const String mmmDYyyy = 'MMMM d, yyyy';
const String hhMm = 'HH:mm';
const String hhMmA = 'hh:mm a';

/// Parse date string to DateTime
DateTime? parseDate(
  String? dateString, {
  bool withHours = false,
  bool withTimezone = true,
}) {
  if (dateString == null || dateString.isEmpty) {
    return null;
  }

  try {
    final pattern = withHours ? 'yyyy-MM-ddTHH:mm:ss' : 'yyyy-MM-dd';
    return DateFormat(pattern).parse(dateString, withTimezone);
  } catch (e) {
    return null;
  }
}

/// Generic date formatting
String formatDateTime(
  DateTime? dateTime,
  String format, {
  String defaultString = '',
}) {
  if (dateTime == null || format.isEmpty) {
    return defaultString;
  }
  try {
    return DateFormat(format).format(dateTime);
  } catch (e) {
    return defaultString;
  }
}

// Convenience formatters

String formatDdMmYyyy(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, ddMmYyyy, defaultString: defaultString);

String formatYyyy(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, yyyy, defaultString: defaultString);

String formatMmmDYyyy(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, mmmDYyyy, defaultString: defaultString);

String formatYyyyMmDd(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, yyyyMmDd, defaultString: defaultString);

String formatYyyyMmDdHhMmSs(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, yyyyMmDdHhMmSs, defaultString: defaultString);

String formatMmYyyy(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, mmYyyy, defaultString: defaultString);

String formatMmmYy(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, mmmYy, defaultString: defaultString);

String formatDdMmm(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, ddMmm, defaultString: defaultString);

String formatDdMmmDot(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, ddMmmDot, defaultString: defaultString);

String formatHhMm(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, hhMm, defaultString: defaultString);

String formatHhMmA(DateTime? dateTime, {String defaultString = ''}) =>
    formatDateTime(dateTime, hhMmA, defaultString: defaultString);

/// Get today at midnight
DateTime today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Add time to date
DateTime addDate({
  DateTime? initialDate,
  int days = 0,
  int months = 0,
  int years = 0,
}) {
  final now = initialDate ?? DateTime.now();
  return DateTime(
    now.year + years,
    now.month + months,
    now.day + days,
    now.hour,
    now.minute,
    now.second,
  );
}

/// Display timestamp in human-readable format (today, yesterday, X days ago)
String displayTimeStamp(DateTime timestamp, {
  required String todayLabel,
  required String yesterdayLabel,
  required String daysAgoLabel,
  required String weeksAgoLabel,
  required String oneWeekAgoLabel,
}) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);
  final days = difference.inDays;

  if (days == 0) {
    return todayLabel;
  } else if (days == 1) {
    return yesterdayLabel;
  } else if (days < 7) {
    return '$days $daysAgoLabel';
  } else {
    final weeks = (days / 7).floor();
    return weeks == 1 ? oneWeekAgoLabel : '$weeks $weeksAgoLabel';
  }
}

/// Check if two dates are at least one month apart
bool isAtLeastOneMonthApart(DateTime startDate, DateTime endDate) =>
    endDate.difference(startDate).inDays >= 30;

/// Check if date is in the past
bool isPast(DateTime date) => date.isBefore(DateTime.now());

/// Check if date is in the future
bool isFuture(DateTime date) => date.isAfter(DateTime.now());

/// Check if date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

/// Get start of day (midnight)
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Get end of day (23:59:59.999)
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}
