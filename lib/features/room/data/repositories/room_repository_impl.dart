import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/room_code_generator.dart';
import '../../domain/models/room_model.dart';
import '../../domain/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final FirebaseFirestore _firestore;

  RoomRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _roomsRef =>
      _firestore.collection('rooms');

  @override
  Future<String> createRoom({required String uid}) async {
    try {
      String roomCode = RoomCodeGenerator.generate();
      DocumentReference<Map<String, dynamic>> docRef = _roomsRef.doc(roomCode);

      // Verify code uniqueness (collision check)
      final existingDoc = await docRef.get();
      if (existingDoc.exists) {
        // Regenerate in the rare case of collision
        roomCode = RoomCodeGenerator.generate();
        docRef = _roomsRef.doc(roomCode);
      }

      await docRef.set({
        'roomCode': roomCode,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': uid,
        'memberCount': 1,
        'isActive': true,
      });

      return roomCode;
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to create room in Firestore.',
        e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error creating room: $e');
    }
  }

  @override
  Future<RoomModel> getRoom(String roomCode) async {
    try {
      final doc = await _roomsRef.doc(roomCode.toUpperCase()).get();
      if (!doc.exists) {
        throw RoomNotFoundException('Room #$roomCode does not exist.');
      }
      return RoomModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to retrieve room.',
        e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error fetching room: $e');
    }
  }

  @override
  Future<bool> validateRoom(String roomCode) async {
    try {
      final doc = await _roomsRef.doc(roomCode.toUpperCase()).get();
      if (!doc.exists) return false;
      final data = doc.data();
      return (data?['isActive'] as bool? ?? true);
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Failed to validate room.',
        e.code,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException('Unexpected error validating room: $e');
    }
  }
}
