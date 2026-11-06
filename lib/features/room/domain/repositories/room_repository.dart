import '../models/room_model.dart';

abstract class RoomRepository {
  /// Generates a new 6-digit room and writes document to Firestore.
  /// Returns the generated roomCode.
  Future<String> createRoom({required String uid});

  /// Retrieves room details by room code.
  /// Throws RoomNotFoundException if room doesn't exist.
  Future<RoomModel> getRoom(String roomCode);

  /// Checks if a room document exists in Firestore and is active.
  Future<bool> validateRoom(String roomCode);
}
