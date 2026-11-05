import 'package:flutter/material.dart';

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
          builder: (_) => const Scaffold(
            body: Center(child: Text('Join Room (Placeholder)')),
          ),
          settings: settings,
        );

      case AppRoutes.identityReveal:
        final args = settings.arguments as IdentityRevealArgs?;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Identity Reveal for Room: ${args?.roomCode ?? "Unknown"}'),
            ),
          ),
          settings: settings,
        );

      case AppRoutes.chat:
        final args = settings.arguments as ChatArgs?;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Chat in Room: ${args?.roomCode ?? "Unknown"} as ${args?.username ?? "Anonymous"}'),
            ),
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

