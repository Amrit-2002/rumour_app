import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/chat/domain/models/message_model.dart';

void main() {
  group('MessageModel Tests', () {
    test('Constructs with required parameters and default pending flag', () {
      final now = DateTime.now();
      final msg = MessageModel(
        id: 'msg_99',
        senderId: 'uid_test',
        senderName: 'Cosmic Otter',
        text: 'Encrypted payload',
        createdAt: now,
      );

      expect(msg.id, equals('msg_99'));
      expect(msg.senderId, equals('uid_test'));
      expect(msg.senderName, equals('Cosmic Otter'));
      expect(msg.text, equals('Encrypted payload'));
      expect(msg.createdAt, equals(now));
      expect(msg.isPending, isFalse);
    });

    test('isPending can be explicitly set to true for offline queued writes', () {
      final msg = MessageModel(
        id: 'msg_100',
        senderId: 'uid_test',
        senderName: 'Cosmic Otter',
        text: 'Offline queued message',
        createdAt: DateTime.now(),
        isPending: true,
      );

      expect(msg.isPending, isTrue);
    });

    test('toMap produces schema suitable for Firestore document set', () {
      final msg = MessageModel(
        id: 'msg_101',
        senderId: 'uid_test',
        senderName: 'Neon Falcon',
        text: 'Rumour test',
        createdAt: DateTime(2026, 11, 6),
      );

      final map = msg.toMap();
      expect(map['id'], equals('msg_101'));
      expect(map['senderId'], equals('uid_test'));
      expect(map['senderName'], equals('Neon Falcon'));
      expect(map['text'], equals('Rumour test'));
      expect(map.containsKey('createdAt'), isTrue);
    });
  });
}
