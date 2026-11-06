import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/core/constants/app_constants.dart';
import 'package:rumour/core/utils/room_code_generator.dart';

void main() {
  group('RoomCodeGenerator Tests', () {
    test('generate() produces code with exactly roomCodeLength characters', () {
      final code = RoomCodeGenerator.generate();
      expect(code.length, equals(AppConstants.roomCodeLength));
    });

    test('generate() excludes ambiguous characters 0, O, 1, I', () {
      final ambiguous = ['0', 'O', '1', 'I'];
      for (int i = 0; i < 100; i++) {
        final code = RoomCodeGenerator.generate();
        for (final char in ambiguous) {
          expect(code.contains(char), isFalse,
              reason: 'Code $code contains ambiguous character $char');
        }
      }
    });

    test('generate() supports custom length override', () {
      final code4 = RoomCodeGenerator.generate(4);
      expect(code4.length, equals(4));

      final code8 = RoomCodeGenerator.generate(8);
      expect(code8.length, equals(8));
    });
  });
}

