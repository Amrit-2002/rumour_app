abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No network connection detected. Working offline.']);
}

class RoomNotFoundFailure extends Failure {
  const RoomNotFoundFailure([super.message = 'Room not found. Please check your 6-digit code.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Anonymous sign-in failed. Please retry.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

