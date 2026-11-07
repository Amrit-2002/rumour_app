import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  final double size;

  const ThemeToggleButton({
    super.key,
    this.size = 38.0,
  });

  void _showThemeSelectionSheet(BuildContext context, ThemeProvider themeProvider) {
    final colors = context.colors;
    final currentMode = themeProvider.themeMode;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colors.secondaryText.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Choose Theme',
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'System default',
                  subtitle: 'Matches your device settings',
                  icon: Icons.brightness_auto_rounded,
                  isSelected: currentMode == ThemeMode.system,
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'Dark mode',
                  subtitle: 'Deep stealth look matching Figma',
                  icon: Icons.dark_mode_rounded,
                  isSelected: currentMode == ThemeMode.dark,
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.dark);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'Light mode',
                  subtitle: 'Crisp, high-contrast light theme',
                  icon: Icons.light_mode_rounded,
                  isSelected: currentMode == ThemeMode.light,
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.light);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryAccent : colors.secondarySurface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? colors.darkText : colors.primaryText,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colors.primaryText,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colors.secondaryText,
          fontSize: 12,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colors.accentText)
          : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider?>();
    final isDark = themeProvider?.isDarkMode(context) ??
        Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () {
            if (themeProvider != null) {
              themeProvider.toggleTheme(context);
            }
          },
          onLongPress: themeProvider != null
              ? () => _showThemeSelectionSheet(context, themeProvider)
              : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: colors.secondarySurface,
              shape: BoxShape.circle,
              border: Border.all(color: colors.borderLight, width: 1),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  color: isDark ? colors.primaryAccent : colors.primaryText,
                  size: size * 0.52,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
