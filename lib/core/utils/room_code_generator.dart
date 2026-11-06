import 'dart:math';
import '../constants/app_constants.dart';

class RoomCodeGenerator {
  RoomCodeGenerator._();

  static final Random _random = Random.secure();

  /// Generates a 6-character collision-resistant uppercase alphanumeric code
  /// omitting visually ambiguous characters (like 0/O, 1/I).
  static String generate([int length = AppConstants.roomCodeLength]) {
    final buffer = StringBuffer();
    final charset = AppConstants.roomCodeCharset;
    for (int i = 0; i < length; i++) {
      final index = _random.nextInt(charset.length);
      buffer.write(charset[index]);
    }
    return buffer.toString();
  }
}

