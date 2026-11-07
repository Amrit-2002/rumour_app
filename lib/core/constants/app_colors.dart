import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Palette defaults (preserved for static backwards-compatibility)
  static const Color background = Color(0xFF09090B);
  static const Color surface = Color(0xFF101521);
  static const Color secondarySurface = Color(0xFF1F2937);
  static const Color cardSurface = Color(0xFF101521);
  static const Color badgeSurface = Color(0xFF27272A);
  static const Color inputSurface = Color(0xFF101521);

  // Brand / Accents
  static const Color primaryAccent = Color(0xFFBDF84F); // Neon Lime matching Figma & Logo
  static const Color errorAccent = Color(0xFFFF4D4D);
  static const Color syncPending = Color(0xFFFFB836);

  // Typography
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF94A3B8);
  static const Color darkText = Color(0xFF09090B);

  // Chat specific
  static const Color bubbleReceived = Color(0xFF101521);
  static const Color bubbleSent = Color(0xFFBDF84F);
  static const Color dateChipBackground = Color(0xFF1E2530);

  // Borders & Dividers
  static const Color borderLight = Color(0x1AFFFFFF); // rgba(255,255,255,0.10)
  static const Color borderFocused = Color(0xFFBDF84F);
  static const Color borderInput = Color(0xFF1F2937);

  /// Resolves the active [AppColorsExtension] based on the current theme context.
  static AppColorsExtension of(BuildContext context) {
    final extension = Theme.of(context).extension<AppColorsExtension>();
    if (extension != null) return extension;
    return Theme.of(context).brightness == Brightness.light
        ? AppColorsExtension.light
        : AppColorsExtension.dark;
  }
}

/// Material 3 theme extension providing custom semantic color tokens for both light and dark themes.
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color background;
  final Color surface;
  final Color secondarySurface;
  final Color cardSurface;
  final Color badgeSurface;
  final Color inputSurface;
  final Color primaryAccent;
  final Color accentText;
  final Color errorAccent;
  final Color syncPending;
  final Color primaryText;
  final Color secondaryText;
  final Color darkText;
  final Color bubbleReceived;
  final Color bubbleSent;
  final Color bubbleReceivedText;
  final Color bubbleSentText;
  final Color dateChipBackground;
  final Color borderLight;
  final Color borderFocused;
  final Color borderInput;

  const AppColorsExtension({
    required this.background,
    required this.surface,
    required this.secondarySurface,
    required this.cardSurface,
    required this.badgeSurface,
    required this.inputSurface,
    required this.primaryAccent,
    required this.accentText,
    required this.errorAccent,
    required this.syncPending,
    required this.primaryText,
    required this.secondaryText,
    required this.darkText,
    required this.bubbleReceived,
    required this.bubbleSent,
    required this.bubbleReceivedText,
    required this.bubbleSentText,
    required this.dateChipBackground,
    required this.borderLight,
    required this.borderFocused,
    required this.borderInput,
  });

  static const dark = AppColorsExtension(
    background: Color(0xFF09090B),
    surface: Color(0xFF101521),
    secondarySurface: Color(0xFF1F2937),
    cardSurface: Color(0xFF101521),
    badgeSurface: Color(0xFF27272A),
    inputSurface: Color(0xFF101521),
    primaryAccent: Color(0xFFBDF84F),
    accentText: Color(0xFFBDF84F),
    errorAccent: Color(0xFFFF4D4D),
    syncPending: Color(0xFFFFB836),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFF94A3B8),
    darkText: Color(0xFF09090B),
    bubbleReceived: Color(0xFF101521),
    bubbleSent: Color(0xFFBDF84F),
    bubbleReceivedText: Color(0xFFFFFFFF),
    bubbleSentText: Color(0xFF09090B),
    dateChipBackground: Color(0xFF1E2530),
    borderLight: Color(0x1AFFFFFF),
    borderFocused: Color(0xFFBDF84F),
    borderInput: Color(0xFF1F2937),
  );

  static const light = AppColorsExtension(
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    secondarySurface: Color(0xFFF1F5F9),
    cardSurface: Color(0xFFFFFFFF),
    badgeSurface: Color(0xFFE2E8F0),
    inputSurface: Color(0xFFF1F5F9),
    primaryAccent: Color(0xFFBDF84F),
    accentText: Color(0xFF4D7C0F), // Rich lime-green for optimal contrast on light cards
    errorAccent: Color(0xFFDC2626),
    syncPending: Color(0xFFD97706),
    primaryText: Color(0xFF0F172A), // Slate 900
    secondaryText: Color(0xFF64748B), // Slate 500
    darkText: Color(0xFF09090B),
    bubbleReceived: Color(0xFFF1F5F9), // Slate 100
    bubbleSent: Color(0xFFBDF84F),
    bubbleReceivedText: Color(0xFF0F172A),
    bubbleSentText: Color(0xFF09090B),
    dateChipBackground: Color(0xFFE2E8F0), // Slate 200
    borderLight: Color(0xFFE2E8F0),
    borderFocused: Color(0xFF4D7C0F),
    borderInput: Color(0xFFCBD5E1),
  );

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? surface,
    Color? secondarySurface,
    Color? cardSurface,
    Color? badgeSurface,
    Color? inputSurface,
    Color? primaryAccent,
    Color? accentText,
    Color? errorAccent,
    Color? syncPending,
    Color? primaryText,
    Color? secondaryText,
    Color? darkText,
    Color? bubbleReceived,
    Color? bubbleSent,
    Color? bubbleReceivedText,
    Color? bubbleSentText,
    Color? dateChipBackground,
    Color? borderLight,
    Color? borderFocused,
    Color? borderInput,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      secondarySurface: secondarySurface ?? this.secondarySurface,
      cardSurface: cardSurface ?? this.cardSurface,
      badgeSurface: badgeSurface ?? this.badgeSurface,
      inputSurface: inputSurface ?? this.inputSurface,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      accentText: accentText ?? this.accentText,
      errorAccent: errorAccent ?? this.errorAccent,
      syncPending: syncPending ?? this.syncPending,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      darkText: darkText ?? this.darkText,
      bubbleReceived: bubbleReceived ?? this.bubbleReceived,
      bubbleSent: bubbleSent ?? this.bubbleSent,
      bubbleReceivedText: bubbleReceivedText ?? this.bubbleReceivedText,
      bubbleSentText: bubbleSentText ?? this.bubbleSentText,
      dateChipBackground: dateChipBackground ?? this.dateChipBackground,
      borderLight: borderLight ?? this.borderLight,
      borderFocused: borderFocused ?? this.borderFocused,
      borderInput: borderInput ?? this.borderInput,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      secondarySurface: Color.lerp(secondarySurface, other.secondarySurface, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      badgeSurface: Color.lerp(badgeSurface, other.badgeSurface, t)!,
      inputSurface: Color.lerp(inputSurface, other.inputSurface, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      errorAccent: Color.lerp(errorAccent, other.errorAccent, t)!,
      syncPending: Color.lerp(syncPending, other.syncPending, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      darkText: Color.lerp(darkText, other.darkText, t)!,
      bubbleReceived: Color.lerp(bubbleReceived, other.bubbleReceived, t)!,
      bubbleSent: Color.lerp(bubbleSent, other.bubbleSent, t)!,
      bubbleReceivedText: Color.lerp(bubbleReceivedText, other.bubbleReceivedText, t)!,
      bubbleSentText: Color.lerp(bubbleSentText, other.bubbleSentText, t)!,
      dateChipBackground: Color.lerp(dateChipBackground, other.dateChipBackground, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderFocused: Color.lerp(borderFocused, other.borderFocused, t)!,
      borderInput: Color.lerp(borderInput, other.borderInput, t)!,
    );
  }
}

/// Convenient extension on [BuildContext] to access theme colors directly via `context.colors`.
extension ThemeColorsContextExtension on BuildContext {
  AppColorsExtension get colors => AppColors.of(this);
}
