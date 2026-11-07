import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rumour/core/services/storage_service.dart';
import 'package:rumour/core/theme/app_theme.dart';
import 'package:rumour/core/theme/theme_provider.dart';
import 'package:rumour/core/widgets/theme_toggle_button.dart';
import 'package:rumour/features/chat/presentation/screens/group_chat_screen.dart';
import 'package:rumour/features/identity/presentation/screens/identity_reveal_screen.dart';
import 'package:rumour/features/room/presentation/screens/join_room_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Theme Switching & Widget Integration Tests', () {
    late StorageService storageService;
    late ThemeProvider themeProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
      themeProvider = ThemeProvider(storageService);
    });

    Widget createThemedTestApp({required Widget child}) {
      return ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: Consumer<ThemeProvider>(
          builder: (context, provider, _) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: provider.themeMode,
              home: Scaffold(body: child),
            );
          },
        ),
      );
    }

    testWidgets('ThemeToggleButton displays light_mode icon in dark mode and dark_mode icon in light mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(createThemedTestApp(child: const ThemeToggleButton()));
      await tester.pumpAndSettle();

      // Initially in dark mode -> shows Sun icon (to switch to light)
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_rounded), findsNothing);

      // Tap toggle button
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      // Now in light mode -> shows Moon icon (to switch to dark)
      expect(themeProvider.themeMode, equals(ThemeMode.light));
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_rounded), findsNothing);

      // Tap again -> switches back to dark mode
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      expect(themeProvider.themeMode, equals(ThemeMode.dark));
      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });

    testWidgets('JoinRoomScreen integrates ThemeToggleButton and toggles themes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: provider.themeMode,
                home: const JoinRoomScreen(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeToggleButton), findsOneWidget);
      expect(find.text('Join A Room'), findsOneWidget);

      // Verify toggle button works on JoinRoomScreen
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      expect(themeProvider.themeMode, equals(ThemeMode.light));
    });

    testWidgets('IdentityRevealScreen integrates ThemeToggleButton and renders in light theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: provider.themeMode,
                home: const IdentityRevealScreen(
                  roomCode: '123456',
                  initialAdjective: 'Silent',
                  initialAnimal: 'Falcon',
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeToggleButton), findsOneWidget);
      expect(find.text('Silent\nFalcon'), findsOneWidget);

      // Switch to light theme
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      expect(themeProvider.themeMode, equals(ThemeMode.light));
      expect(find.text('Silent\nFalcon'), findsOneWidget);
    });

    testWidgets('GroupChatScreen integrates ThemeToggleButton and toggles themes cleanly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: provider.themeMode,
                home: const GroupChatScreen(
                  roomCode: '123456',
                  username: 'Silent Falcon',
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ThemeToggleButton), findsOneWidget);
      expect(find.text('Room #123456'), findsOneWidget);

      // Tap toggle button in chat screen
      await tester.tap(find.byType(ThemeToggleButton));
      await tester.pumpAndSettle();

      expect(themeProvider.themeMode, equals(ThemeMode.light));
      expect(find.text('Room #123456'), findsOneWidget);
    });
  });
}
