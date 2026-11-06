import '../constants/app_constants.dart';

class InputValidator {
  InputValidator._();

  static final RegExp _roomCodeRegex = RegExp(r'^[0-9A-Z]{6}$');

  /// Validates a 6-character room code.
  /// Returns null if valid, or an error message if invalid.
  static String? validateRoomCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return 'Please enter a 6-digit room code';
    }

    final trimmed = code.trim().toUpperCase();
    if (trimmed.length != AppConstants.roomCodeLength) {
      return 'Room code must be exactly ${AppConstants.roomCodeLength} characters';
    }

    if (!_roomCodeRegex.hasMatch(trimmed)) {
      return 'Code contains invalid characters';
    }

    return null;
  }

  /// Validates chat message text.
  /// Returns null if valid, or an error message if invalid.
  static String? validateMessage(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Message cannot be empty';
    }

    if (text.trim().length > AppConstants.maxMessageLength) {
      return 'Message exceeds ${AppConstants.maxMessageLength} characters';
    }

    return null;
  }
}
