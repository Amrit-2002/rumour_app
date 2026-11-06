import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;

  ChatProvider(this._chatRepository);

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;
  String? _activeRoomCode;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  String? get activeRoomCode => _activeRoomCode;

  /// Connects to real-time message stream for the specified room.
  void enterRoom({
    required String roomCode,
    required String uid,
    required String username,
  }) {
    if (_activeRoomCode == roomCode && _messagesSubscription != null) {
      return; // Already listening to this room
    }

    _leaveRoomInternal();
    _activeRoomCode = roomCode.toUpperCase();
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Register member in background
    _chatRepository.registerMember(
      roomCode: roomCode,
      uid: uid,
      username: username,
    );

    // Subscribe to Firestore snapshots
    _messagesSubscription = _chatRepository
        .getMessagesStream(roomCode)
        .listen(
      (newMessages) {
        _messages = newMessages;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error is AppException ? error.message : 'Chat error: $error';
        notifyListeners();
      },
    );
  }

  /// Sends a message into the active room.
  Future<bool> sendMessage({
    required String roomCode,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    if (text.trim().isEmpty) return false;

    _isSending = true;
    notifyListeners();

    try {
      await _chatRepository.sendMessage(
        roomCode: roomCode,
        text: text,
        senderId: senderId,
        senderName: senderName,
      );
      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSending = false;
      _errorMessage = e is AppException ? e.message : 'Failed to send: $e';
      notifyListeners();
      return false;
    }
  }

  void _leaveRoomInternal() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _messages = [];
    _activeRoomCode = null;
    _errorMessage = null;
  }

  /// Explicitly terminates listener and frees stream resources.
  void leaveRoom() {
    _leaveRoomInternal();
    notifyListeners();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    super.dispose();
  }
}
