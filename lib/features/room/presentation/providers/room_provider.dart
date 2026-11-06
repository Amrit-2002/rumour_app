import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/models/room_model.dart';
import '../../domain/repositories/room_repository.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepository;

  RoomProvider(this._roomRepository);

  bool _isLoading = false;
  String? _errorMessage;
  String? _activeRoomCode;
  RoomModel? _activeRoom;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get activeRoomCode => _activeRoomCode;
  RoomModel? get activeRoom => _activeRoom;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Creates a new room in Firestore using the user's anonymous UID.
  Future<String?> createRoom(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final code = await _roomRepository.createRoom(uid: uid);
      _activeRoomCode = code;
      try {
        _activeRoom = await _roomRepository.getRoom(code);
      } catch (_) {}
      _isLoading = false;
      notifyListeners();
      return code;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException ? e.message : 'Failed to create room: $e';
      notifyListeners();
      return null;
    }
  }

  /// Validates that a room exists and is active.
  Future<bool> joinRoom(String roomCode) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final room = await _roomRepository.getRoom(roomCode);
      if (!room.isActive) {
        _errorMessage = 'Room is no longer active.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _activeRoom = room;
      _activeRoomCode = roomCode.toUpperCase();
      _isLoading = false;
      notifyListeners();
      return true;
    } on RoomNotFoundException {
      _errorMessage = 'Room not found. Please check your code or create a new room.';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e is AppException ? e.message : 'Error validating room: $e';
      notifyListeners();
      return false;
    }
  }

  void leaveRoom() {
    _activeRoomCode = null;
    _activeRoom = null;
    _errorMessage = null;
    notifyListeners();
  }
}

