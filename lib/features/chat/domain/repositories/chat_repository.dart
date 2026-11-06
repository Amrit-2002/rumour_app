import '../models/message_model.dart';

abstract class ChatRepository {
  /// Real-time stream of messages for a room, ordered newest first (descending).
  Stream<List<MessageModel>> getMessagesStream(String roomCode);

  /// Real-time stream of the member count for a room.
  Stream<int> getMemberCountStream(String roomCode);

  /// Sends a message into the room's messages subcollection.
  Future<void> sendMessage({
    required String roomCode,
    required String text,
    required String senderId,
    required String senderName,
  });

  /// Fetches older messages using cursor pagination.
  Future<List<MessageModel>> fetchOlderMessages({
    required String roomCode,
    required dynamic lastDocument,
    int limit = 20,
  });

  /// Registers user membership and increments room member counter if first join.
  Future<void> registerMember({
    required String roomCode,
    required String uid,
    required String username,
  });
}

