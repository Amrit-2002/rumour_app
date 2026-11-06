import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/models/message_model.dart';
import '../../domain/models/paginated_messages.dart';
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getRawMessagesStream(String roomCode) {
    return _messagesRef(roomCode)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots(includeMetadataChanges: true);
  }

  @override
  Stream<int> getMemberCountStream(String roomCode) {
    final code = roomCode.toUpperCase();
    final roomDoc = _firestore.collection('rooms').doc(code);

    return roomDoc
        .collection('members')
        .snapshots(includeMetadataChanges: true)
        .asyncMap((membersSnap) async {
      if (membersSnap.docs.isNotEmpty) {
        return membersSnap.docs.length;
      }
      try {
        final doc = await roomDoc.get();
        final count = (doc.data()?['memberCount'] as num?)?.toInt();
        if (count != null && count > 0) return count;
      } catch (_) {}
      return 1;
    }).handleError((_) => 1);
  }

  @override
  Future<PaginatedMessages> fetchOlderMessages({
    required String roomCode,
    required dynamic lastDocument,
    int limit = 20,
  }) async {
    try {
      if (lastDocument is! DocumentSnapshot) {
        return const PaginatedMessages(messages: []);
      }

      final querySnapshot = await _messagesRef(roomCode)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();

      final messages =
          querySnapshot.docs.map(MessageModel.fromFirestore).toList();
      final nextCursor =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return PaginatedMessages(
        messages: messages,
        lastDocument: nextCursor,
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to fetch older messages.',
        e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error fetching history: $e');
    }
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
        'roomCode': roomCode.toUpperCase(),
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

  @override
  Future<void> unregisterMember({
    required String roomCode,
    required String uid,
  }) async {
    try {
      final roomDoc = _firestore.collection('rooms').doc(roomCode.toUpperCase());
      final memberRef = roomDoc.collection('members').doc(uid);

      final doc = await memberRef.get();
      if (doc.exists) {
        await memberRef.delete();
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(roomDoc);
          if (snapshot.exists) {
            final currentCount =
                (snapshot.data()?['memberCount'] as num?)?.toInt() ?? 1;
            final newCount = currentCount > 1 ? currentCount - 1 : 0;
            transaction.update(roomDoc, {'memberCount': newCount});
          }
        }).catchError((_) {});
      }
    } catch (_) {
      // Non-critical: failure to unregister member does not block chat exit
    }
  }
}

