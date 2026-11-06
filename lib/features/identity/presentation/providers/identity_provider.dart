import 'package:flutter/foundation.dart';
import '../../domain/models/identity_model.dart';
import '../../domain/repositories/identity_repository.dart';

class IdentityProvider extends ChangeNotifier {
  final IdentityRepository _identityRepository;

  IdentityProvider(this._identityRepository);

  IdentityModel? _currentIdentity;
  bool _isLoading = false;
  String? _errorMessage;

  IdentityModel? get currentIdentity => _currentIdentity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isRestored => _currentIdentity?.isRestored ?? false;

  /// Resolves the anonymous persona for the given room code and device UID.
  Future<IdentityModel?> resolveIdentity({
    required String roomCode,
    required String uid,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final identity = await _identityRepository.getOrCreateIdentity(
        roomCode: roomCode,
        uid: uid,
      );
      _currentIdentity = identity;
      _isLoading = false;
      notifyListeners();
      return identity;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to resolve identity: $e';
      notifyListeners();
      return null;
    }
  }

  void clear() {
    _currentIdentity = null;
    _errorMessage = null;
    notifyListeners();
  }
}

