import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/identity/domain/models/identity_model.dart';
import 'package:rumour/features/identity/domain/services/identity_generator.dart';

void main() {
  group('IdentityGenerator', () {
    test('generate() returns valid Adjective and Animal from curated lists', () {
      for (int i = 0; i < 50; i++) {
        final persona = IdentityGenerator.generate();
        expect(IdentityGenerator.adjectives.contains(persona.adjective), isTrue,
            reason: 'Adjective ${persona.adjective} must be in curated list');
        expect(IdentityGenerator.animals.contains(persona.animal), isTrue,
            reason: 'Animal ${persona.animal} must be in curated list');
        expect(persona.fullName, equals('${persona.adjective} ${persona.animal}'));
      }
    });
  });

  group('IdentityModel', () {
    test('toJson and fromJson preserves all fields and restored status', () {
      final now = DateTime(2026, 11, 5, 20, 30);
      final model = IdentityModel(
        adjective: 'Brave',
        animal: 'Badger',
        roomCode: 'RM7K29',
        uid: 'user_xyz',
        assignedAt: now,
        isRestored: false,
      );

      final jsonString = model.toJson();
      final restored = IdentityModel.fromJson(jsonString, isRestored: true);

      expect(restored.adjective, equals('Brave'));
      expect(restored.animal, equals('Badger'));
      expect(restored.fullName, equals('Brave Badger'));
      expect(restored.roomCode, equals('RM7K29'));
      expect(restored.uid, equals('user_xyz'));
      expect(restored.assignedAt.year, equals(2026));
      expect(restored.isRestored, isTrue);
    });

    test('copyWith properly overrides specified fields', () {
      final model = IdentityModel(
        adjective: 'Silent',
        animal: 'Otter',
        roomCode: '112233',
        uid: 'uid_1',
        assignedAt: DateTime.now(),
      );

      final updated = model.copyWith(uid: 'uid_2', isRestored: true);
      expect(updated.uid, equals('uid_2'));
      expect(updated.isRestored, isTrue);
      expect(updated.adjective, equals('Silent'));
      expect(updated.animal, equals('Otter'));
    });
  });
}

