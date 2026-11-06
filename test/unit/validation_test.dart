import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/core/utils/input_validator.dart';

void main() {
  group('InputValidator - Room Code', () {
    test('rejects null and empty code', () {
      expect(InputValidator.validateRoomCode(null), isNotNull);
      expect(InputValidator.validateRoomCode(''), isNotNull);
      expect(InputValidator.validateRoomCode('   '), isNotNull);
    });

    test('rejects codes shorter or longer than 6 characters', () {
      expect(InputValidator.validateRoomCode('ABC12'), isNotNull);
      expect(InputValidator.validateRoomCode('ABC1234'), isNotNull);
    });

    test('accepts valid 6-character room codes', () {
      expect(InputValidator.validateRoomCode('581290'), isNull);
      expect(InputValidator.validateRoomCode('RM7K29'), isNull);
    });
  });

  group('InputValidator - Message Content', () {
    test('rejects empty or whitespace-only messages', () {
      expect(InputValidator.validateMessage(null), isNotNull);
      expect(InputValidator.validateMessage(''), isNotNull);
      expect(InputValidator.validateMessage('     '), isNotNull);
    });

    test('rejects messages exceeding 500 characters', () {
      final longText = 'A' * 501;
      expect(InputValidator.validateMessage(longText), isNotNull);
    });

    test('accepts valid messages within 1 to 500 characters', () {
      expect(InputValidator.validateMessage('Hello anonymous room!'), isNull);
      final validLongText = 'B' * 500;
      expect(InputValidator.validateMessage(validLongText), isNull);
    });
  });
}

