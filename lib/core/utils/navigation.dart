import 'package:flutter/material.dart';
import '../../features/chat/presentation/screens/group_chat_screen.dart';
import '../../features/identity/presentation/screens/identity_reveal_screen.dart';
import '../../features/room/presentation/screens/join_room_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String joinRoom = '/';
  static const String identityReveal = '/identity-reveal';
  static const String chat = '/chat';
}

class IdentityRevealArgs {
  final String roomCode;

  const IdentityRevealArgs({required this.roomCode});
}

class ChatArgs {
  final String roomCode;
  final String username;

  const ChatArgs({
    required this.roomCode,
    required this.username,
  });
}

class AppNavigator {
  AppNavigator._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.joinRoom:
        return MaterialPageRoute(
          builder: (_) => const JoinRoomScreen(),
          settings: settings,
        );

      case AppRoutes.identityReveal:
        final args = settings.arguments as IdentityRevealArgs?;
        return MaterialPageRoute(
          builder: (_) => IdentityRevealScreen(
            roomCode: args?.roomCode ?? 'DEMO99',
          ),
          settings: settings,
        );

      case AppRoutes.chat:
        final args = settings.arguments as ChatArgs?;
        return MaterialPageRoute(
          builder: (_) => GroupChatScreen(
            roomCode: args?.roomCode ?? 'DEMO99',
            username: args?.username ?? 'Anonymous',
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
