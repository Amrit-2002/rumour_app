import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messagesRef(String roomCode) {
    return _firestore
        .collection('rooms')
        .doc(roomCode.toUpperCase())
        .collection('messages');
  }

  @override
  Stream<List<MessageModel>> getMessagesStream(String roomCode) {
    return _messagesRef(roomCode)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
      return snapshot.docs.map(MessageModel.fromFirestore).toList();
    }).handleError((error) {
      if (error is FirebaseException && error.code == 'permission-denied') {
        throw const ServerException(
          'Permission denied reading messages. Check Firestore rules in console.',
          'permission-denied',
        );
      }
      throw ServerException('Failed to read messages stream: $error');
    });
  }

  @override
  Future<void> sendMessage({
    required String roomCode,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    try {
      final docRef = _messagesRef(roomCode).doc();
      await docRef.set({
        'id': docRef.id,
        'senderId': senderId,
        'senderName': senderName.trim(),
        'text': text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const ServerException(
          'Permission denied sending message. Check Firestore rules in console.',
          'permission-denied',
        );
      }
      throw ServerException(
        e.message ?? 'Failed to send message.',
        e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error sending message: $e');
    }
  }

  @override
  Future<void> registerMember({
    required String roomCode,
    required String uid,
    required String username,
  }) async {
    try {
      final roomDoc = _firestore.collection('rooms').doc(roomCode.toUpperCase());
      final memberRef = roomDoc.collection('members').doc(uid);

      final doc = await memberRef.get();
      if (!doc.exists) {
        await memberRef.set({
          'uid': uid,
          'username': username.trim(),
          'joinedAt': FieldValue.serverTimestamp(),
        });
        await roomDoc.update({
          'memberCount': FieldValue.increment(1),
        }).catchError((_) {});
      }
    } catch (_) {
      // Non-critical: failure to register member counter does not block chat
    }
  }
}
