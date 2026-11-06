import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/models/identity_model.dart';
import '../../domain/repositories/identity_repository.dart';
import '../datasources/random_user_remote_datasource.dart';

class IdentityRepositoryImpl implements IdentityRepository {
  final StorageService _storageService;
  final RandomUserRemoteDataSource _remoteDataSource;

  IdentityRepositoryImpl(
    this._storageService, {
    RandomUserRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? RandomUserRemoteDataSource();

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

    // 1. Check whether the room identity exists locally.
    final existing = await getStoredIdentity(code);
    if (existing != null) {
      // 2. If it exists, reuse it without making an API request.
      final updated = existing.copyWith(uid: uid, isRestored: true);
      await saveIdentity(updated);
      await _storageService.setString(AppConstants.prefLastActiveRoom, code);
      return updated;
    }

    // 3. Otherwise, call RandomUser API.
    final randomUser = await _remoteDataSource.fetchRandomUser();

    // 4. Convert the API response into the required anonymous username format.
    final firstWord = _formatWord(randomUser.firstName);
    final secondWord = _formatWord(randomUser.lastName);
    if (firstWord.isEmpty || secondWord.isEmpty) {
      throw const FormatException('Empty names received from RandomUser API');
    }

    // 5. Save the identity locally.
    final newIdentity = IdentityModel(
      adjective: firstWord,
      animal: secondWord,
      roomCode: code,
      uid: uid,
      assignedAt: DateTime.now(),
      isRestored: false,
    );

    await saveIdentity(newIdentity);
    await _storageService.setString(AppConstants.prefLastActiveRoom, code);

    // 6. Return identity to display.
    return newIdentity;
  }

  static String _formatWord(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase() + trimmed.substring(1);
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
