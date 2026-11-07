import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rumour/core/constants/app_colors.dart';
import 'package:rumour/core/services/storage_service.dart';
import 'package:rumour/core/theme/app_theme.dart';
import 'package:rumour/core/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Unit Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService(prefs);
    });

    test('Initializes with default dark mode when storage has no preference', () {
      final provider = ThemeProvider(storageService);
      expect(provider.themeMode, equals(ThemeMode.dark));
    });

    test('Restores light mode from storage when stored as "light"', () async {
      await storageService.setString(ThemeProvider.themePreferenceKey, 'light');
      final provider = ThemeProvider(storageService);
      expect(provider.themeMode, equals(ThemeMode.light));
    });

    test('Restores dark mode from storage when stored as "dark"', () async {
      await storageService.setString(ThemeProvider.themePreferenceKey, 'dark');
      final provider = ThemeProvider(storageService);
      expect(provider.themeMode, equals(ThemeMode.dark));
    });

    test('Restores system mode from storage when stored as "system"', () async {
      await storageService.setString(ThemeProvider.themePreferenceKey, 'system');
      final provider = ThemeProvider(storageService);
      expect(provider.themeMode, equals(ThemeMode.system));
    });

    test('setThemeMode updates themeMode and persists choice', () async {
      final provider = ThemeProvider(storageService);

      await provider.setThemeMode(ThemeMode.light);
      expect(provider.themeMode, equals(ThemeMode.light));
      expect(storageService.getString(ThemeProvider.themePreferenceKey), equals('light'));

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, equals(ThemeMode.dark));
      expect(storageService.getString(ThemeProvider.themePreferenceKey), equals('dark'));

      await provider.setThemeMode(ThemeMode.system);
      expect(provider.themeMode, equals(ThemeMode.system));
      expect(storageService.getString(ThemeProvider.themePreferenceKey), equals('system'));
    });

    testWidgets('toggleTheme alternates between dark and light', (tester) async {
      final provider = ThemeProvider(storageService);
      expect(provider.themeMode, equals(ThemeMode.dark));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.themeMode,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => provider.toggleTheme(context),
                child: const Text('Toggle'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(provider.themeMode, equals(ThemeMode.light));

      await tester.tap(find.text('Toggle'));
      await tester.pump();
      expect(provider.themeMode, equals(ThemeMode.dark));
    });
  });

  group('AppTheme & Color Extension Tests', () {
    test('Dark theme configures correct brightness, scaffold background and extension', () {
      final theme = AppTheme.darkTheme;

      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.scaffoldBackgroundColor, equals(AppColorsExtension.dark.background));
      expect(theme.extension<AppColorsExtension>(), isNotNull);
      expect(theme.extension<AppColorsExtension>()?.background, equals(AppColorsExtension.dark.background));
      expect(theme.extension<AppColorsExtension>()?.primaryAccent, equals(const Color(0xFFBDF84F)));
    });

    test('Light theme configures correct brightness, scaffold background and extension', () {
      final theme = AppTheme.lightTheme;

      expect(theme.brightness, equals(Brightness.light));
      expect(theme.scaffoldBackgroundColor, equals(AppColorsExtension.light.background));
      expect(theme.extension<AppColorsExtension>(), isNotNull);
      expect(theme.extension<AppColorsExtension>()?.background, equals(AppColorsExtension.light.background));
      expect(theme.extension<AppColorsExtension>()?.primaryText, equals(const Color(0xFF0F172A)));
      expect(theme.extension<AppColorsExtension>()?.bubbleSent, equals(const Color(0xFFBDF84F)));
    });

    test('AppColorsExtension lerp and copyWith work properly', () {
      const dark = AppColorsExtension.dark;
      const light = AppColorsExtension.light;

      final lerped = dark.lerp(light, 0.5);
      expect(lerped, isA<AppColorsExtension>());

      final copied = dark.copyWith(background: const Color(0xFF112233));
      expect(copied.background, equals(const Color(0xFF112233)));
      expect(copied.surface, equals(dark.surface));
    });
  });
}
