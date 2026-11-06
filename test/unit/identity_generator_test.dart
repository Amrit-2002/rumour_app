import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/identity/domain/services/identity_generator.dart';

void main() {
  group('IdentityGenerator Tests', () {
    test('Adjective and animal wordlists contain at least 50 elements each', () {
      expect(IdentityGenerator.adjectives.length, greaterThanOrEqualTo(50));
      expect(IdentityGenerator.animals.length, greaterThanOrEqualTo(50));
    });

    test('generate() returns non-empty formatted persona with two words', () {
      for (int i = 0; i < 25; i++) {
        final persona = IdentityGenerator.generate();
        expect(persona.adjective.isNotEmpty, isTrue);
        expect(persona.animal.isNotEmpty, isTrue);

        final parts = persona.fullName.split(' ');
        expect(parts.length, equals(2));
        expect(parts[0], equals(persona.adjective));
        expect(parts[1], equals(persona.animal));
      }
    });

    test('Wordlist entries are capitalized and contain no whitespace', () {
      for (final adj in IdentityGenerator.adjectives) {
        expect(adj.trim(), equals(adj));
        expect(adj[0], equals(adj[0].toUpperCase()));
      }
      for (final animal in IdentityGenerator.animals) {
        expect(animal.trim(), equals(animal));
        expect(animal[0], equals(animal[0].toUpperCase()));
      }
    });
  });
}
