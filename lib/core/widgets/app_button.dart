import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppButtonVariant { primary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.height = 52.0,
  });

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 48.0,
  }) : variant = AppButtonVariant.outline;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 44.0,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          side: const BorderSide(color: AppColors.secondarySurface, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _buildContent(AppColors.primaryText),
      );
    }

    if (variant == AppButtonVariant.text) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          foregroundColor: AppColors.secondaryText,
        ),
        child: _buildContent(AppColors.secondaryText),
      );
    }

    // Default: Primary (Neon Lime)
    final bool isEnabled = onPressed != null && !isLoading;
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: AppColors.darkText,
        disabledBackgroundColor: AppColors.primaryAccent.withValues(alpha: 0.35),
        disabledForegroundColor: AppColors.darkText.withValues(alpha: 0.5),
        minimumSize: Size.fromHeight(height),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _buildContent(AppColors.darkText),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }
}

