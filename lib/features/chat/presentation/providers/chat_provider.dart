import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;

  ChatProvider(this._chatRepository);

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isFromCache = false;
  String? _errorMessage;
  String? _activeRoomCode;
  dynamic _lastDocumentCursor;
  StreamSubscription? _messagesSubscription;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  bool get isFromCache => _isFromCache;
  bool get hasPendingWrites => _messages.any((m) => m.isPending);
  String? get errorMessage => _errorMessage;
  String? get activeRoomCode => _activeRoomCode;

  /// Connects to real-time message stream for the specified room.
  void enterRoom({
    required String roomCode,
    required String uid,
    required String username,
  }) {
    if (_activeRoomCode == roomCode && _messagesSubscription != null) {
      return; // Already active
    }

    _leaveRoomInternal();
    _activeRoomCode = roomCode.toUpperCase();
    _isLoading = true;
    _hasMore = true;
    _errorMessage = null;
    notifyListeners();

    // Register member in background
    _chatRepository.registerMember(
      roomCode: roomCode,
      uid: uid,
      username: username,
    );

    // Subscribe to Firestore stream
    final repo = _chatRepository;
    if (repo is ChatRepositoryImpl) {
      _messagesSubscription = repo.getRawMessagesStream(roomCode).listen(
        (snapshot) {
          final streamMessages =
              snapshot.docs.map(MessageModel.fromFirestore).toList();
          if (snapshot.docs.isNotEmpty) {
            _lastDocumentCursor = snapshot.docs.last;
          }
          _isFromCache = snapshot.metadata.isFromCache;
          _mergeMessages(streamMessages);
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage =
              error is AppException ? error.message : 'Chat error: $error';
          notifyListeners();
        },
      );
    } else {
      _messagesSubscription = _chatRepository
          .getMessagesStream(roomCode)
          .listen(
        (newMessages) {
          _mergeMessages(newMessages);
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          _isLoading = false;
          _errorMessage =
              error is AppException ? error.message : 'Chat error: $error';
          notifyListeners();
        },
      );
    }
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

  /// Paginates older messages using startAfterDocument cursor.
  Future<void> fetchOlderMessages(String roomCode) async {
    if (!_hasMore || _isLoadingMore || _lastDocumentCursor == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final older = await _chatRepository.fetchOlderMessages(
        roomCode: roomCode,
        lastDocument: _lastDocumentCursor,
        limit: 20,
      );

      if (older.isEmpty) {
        _hasMore = false;
      } else {
        _mergeMessages(older);
      }
    } catch (e) {
      debugPrint('Error fetching older messages: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Deduplicates and orders messages descending (newest first).
  void _mergeMessages(List<MessageModel> newMessages) {
    final Map<String, MessageModel> map = {
      for (final m in _messages) m.id: m,
    };
    for (final m in newMessages) {
      map[m.id] = m;
    }
    _messages = map.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void _leaveRoomInternal() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _messages = [];
    _activeRoomCode = null;
    _lastDocumentCursor = null;
    _isLoadingMore = false;
    _hasMore = true;
    _isFromCache = false;
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
