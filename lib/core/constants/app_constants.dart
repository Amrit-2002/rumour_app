class AppConstants {
  AppConstants._();

  // Application
  static const String appName = 'Rumour';
  static const String appTagline = 'Anonymous Room-Code Chat';

  // Room rules
  static const int roomCodeLength = 6;
  static const String roomCodeCharset = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

  // Message rules
  static const int maxMessageLength = 500;
  static const int messagesPageLimit = 30;

  // Storage keys (SharedPreferences)
  static const String prefUserUid = 'rumour_user_uid';
  static const String prefRoomIdentityPrefix = 'room_identity_';
  static const String prefLastActiveRoom = 'last_active_room';
}

