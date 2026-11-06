import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/features/chat/domain/models/message_model.dart';

void main() {
  group('MessageModel', () {
    test('toMap() prepares correct schema for Firestore messages subcollection', () {
      final now = DateTime(2026, 11, 5, 21, 15);
      final message = MessageModel(
        id: 'msg_001',
        senderId: 'uid_123',
        senderName: 'Brave Badger',
        text: 'This is an anonymous rumour.',
        createdAt: now,
        isPending: false,
      );

      final map = message.toMap();
      expect(map['id'], equals('msg_001'));
      expect(map['senderId'], equals('uid_123'));
      expect(map['senderName'], equals('Brave Badger'));
      expect(map['text'], equals('This is an anonymous rumour.'));
      expect(map.containsKey('createdAt'), isTrue);
    });

    test('MessageModel defaults isPending to false', () {
      final message = MessageModel(
        id: 'msg_002',
        senderId: 'uid_456',
        senderName: 'Velvet Panther',
        text: 'Testing pending flag',
        createdAt: DateTime.now(),
      );

      expect(message.isPending, isFalse);
    });
  });
}
