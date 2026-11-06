import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/models/identity_model.dart';
import '../../domain/repositories/identity_repository.dart';
import '../../domain/services/identity_generator.dart';

class IdentityRepositoryImpl implements IdentityRepository {
  final StorageService _storageService;

  IdentityRepositoryImpl(this._storageService);

  String _getKey(String roomCode) =>
      '${AppConstants.prefRoomIdentityPrefix}${roomCode.toUpperCase()}';

  @override
  Future<IdentityModel?> getStoredIdentity(String roomCode) async {
    final raw = _storageService.getString(_getKey(roomCode));
    if (raw == null || raw.isEmpty) return null;
    try {
      return IdentityModel.fromJson(raw, isRestored: true);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<IdentityModel> getOrCreateIdentity({
    required String roomCode,
    required String uid,
  }) async {
    final code = roomCode.toUpperCase();
    final existing = await getStoredIdentity(code);
    if (existing != null) {
      // Update UID if it changed (e.g. fresh anonymous token)
      final updated = existing.copyWith(uid: uid, isRestored: true);
      await saveIdentity(updated);
      await _storageService.setString(AppConstants.prefLastActiveRoom, code);
      return updated;
    }

    // Generate fresh persona
    final persona = IdentityGenerator.generate();
    final newIdentity = IdentityModel(
      adjective: persona.adjective,
      animal: persona.animal,
      roomCode: code,
      uid: uid,
      assignedAt: DateTime.now(),
      isRestored: false,
    );

    await saveIdentity(newIdentity);
    await _storageService.setString(AppConstants.prefLastActiveRoom, code);
    return newIdentity;
  }

  @override
  Future<void> saveIdentity(IdentityModel identity) async {
    await _storageService.setString(
      _getKey(identity.roomCode),
      identity.toJson(),
    );
  }

  @override
  Future<void> clearRoomIdentity(String roomCode) async {
    await _storageService.remove(_getKey(roomCode));
  }
}
