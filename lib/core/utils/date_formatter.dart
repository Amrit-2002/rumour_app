import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _monthDayYearFormat = DateFormat('MMM d, yyyy');

  /// Formats time as "HH:mm" (e.g. "10:15", "19:42").
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Formats date for separator headers ("Today", "Yesterday", or "Nov 6, 2026").
  static String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(date.year, date.month, date.day);

    if (messageDay == today) {
      return 'Today';
    } else if (messageDay == yesterday) {
      return 'Yesterday';
    } else {
      return _monthDayYearFormat.format(date);
    }
  }

  /// Checks if two timestamps fall on the exact same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

