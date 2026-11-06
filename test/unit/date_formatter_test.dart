import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('formatTime() formats to HH:mm string', () {
      final date = DateTime(2026, 11, 5, 9, 5);
      expect(DateFormatter.formatTime(date), equals('09:05'));

      final datePm = DateTime(2026, 11, 5, 21, 45);
      expect(DateFormatter.formatTime(datePm), equals('21:45'));
    });

    test('formatDateHeader() correctly identifies Today and Yesterday', () {
      final now = DateTime.now();
      expect(DateFormatter.formatDateHeader(now), equals('Today'));

      final yesterday = now.subtract(const Duration(days: 1));
      expect(DateFormatter.formatDateHeader(yesterday), equals('Yesterday'));

      final pastDate = DateTime(2026, 1, 15);
      expect(DateFormatter.formatDateHeader(pastDate), equals('Jan 15, 2026'));
    });

    test('isSameDay() correctly evaluates dates', () {
      final a = DateTime(2026, 11, 5, 10, 0);
      final b = DateTime(2026, 11, 5, 23, 59);
      final c = DateTime(2026, 11, 6, 0, 1);

      expect(DateFormatter.isSameDay(a, b), isTrue);
      expect(DateFormatter.isSameDay(a, c), isFalse);
    });
  });
}
