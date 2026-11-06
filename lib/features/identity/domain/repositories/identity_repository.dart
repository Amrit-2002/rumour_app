import '../models/identity_model.dart';

abstract class IdentityRepository {
  /// Resolves an existing identity stored locally for this room code on this device.
  /// If none exists, generates a fresh (adjective + animal) persona, persists it,
  /// and returns the new identity.
  Future<IdentityModel> getOrCreateIdentity({
    required String roomCode,
    required String uid,
  });

  /// Reads stored identity if previously persisted.
  Future<IdentityModel?> getStoredIdentity(String roomCode);

  /// Saves or updates the local identity for a given room.
  Future<void> saveIdentity(IdentityModel identity);

  /// Clears stored identity for a given room code.
  Future<void> clearRoomIdentity(String roomCode);
}
