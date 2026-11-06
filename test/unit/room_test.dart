import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/core/constants/app_constants.dart';
import 'package:rumour/core/utils/room_code_generator.dart';
import 'package:rumour/features/room/domain/models/room_model.dart';

void main() {
  group('RoomCodeGenerator', () {
    test('generate() produces exactly 6 characters by default', () {
      final code = RoomCodeGenerator.generate();
      expect(code.length, equals(AppConstants.roomCodeLength));
    });

    test('generate() only contains characters from roomCodeCharset', () {
      final charset = AppConstants.roomCodeCharset;
      for (int i = 0; i < 50; i++) {
        final code = RoomCodeGenerator.generate();
        for (int j = 0; j < code.length; j++) {
          expect(charset.contains(code[j]), isTrue,
              reason: 'Character ${code[j]} not in charset');
        }
      }
    });

    test('generate() produces unique codes across calls', () {
      final set = <String>{};
      for (int i = 0; i < 100; i++) {
        set.add(RoomCodeGenerator.generate());
      }
      expect(set.length, equals(100));
    });
  });

  group('RoomModel', () {
    test('toMap() formats fields correctly for Firestore', () {
      final room = RoomModel(
        roomCode: 'RM7K29',
        createdAt: DateTime(2026, 11, 5),
        createdBy: 'uid_123',
        memberCount: 3,
        isActive: true,
      );

      final map = room.toMap();
      expect(map['roomCode'], equals('RM7K29'));
      expect(map['createdBy'], equals('uid_123'));
      expect(map['memberCount'], equals(3));
      expect(map['isActive'], isTrue);
    });
  });
}
