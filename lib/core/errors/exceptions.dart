class AppException implements Exception {
  final String message;
  final String? code;

  const AppException([this.message = 'An error occurred.', this.code]);

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'A server error occurred.',
    super.code,
  ]);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Please check your internet connection.',
    super.code,
  ]);
}

class RoomNotFoundException extends AppException {
  const RoomNotFoundException([
    super.message = 'Room does not exist or has expired.',
    super.code,
  ]);
}

class AuthException extends AppException {
  const AuthException([
    super.message = 'Authentication failed.',
    super.code,
  ]);
}
