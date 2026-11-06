import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class RoomCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final String? errorText;

  const RoomCodeInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Visual Slots Display matching Figma design
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final currentText = value.text;
                return Container(
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.secondarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: errorText != null
                          ? AppColors.errorAccent
                          : AppColors.borderLight,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      final hasChar = index < currentText.length;
                      final isCurrentFocus = index == currentText.length;
                      final char = hasChar ? currentText[index] : '-';

                      return SizedBox(
                        width: 32,
                        child: Text(
                          char,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: hasChar
                                ? AppColors.primaryAccent
                                : (isCurrentFocus
                                    ? AppColors.primaryText
                                    : AppColors.secondaryText.withValues(alpha: 0.4)),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),

            // Invisible Full-Width TextField on top capturing taps & input
            Opacity(
              opacity: 0.0,
              child: SizedBox(
                height: 62,
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  autofocus: false,
                  maxLength: 6,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    LengthLimitingTextInputFormatter(6),
                    _UpperCaseTextFormatter(),
                  ],
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: const TextStyle(
              color: AppColors.errorAccent,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
