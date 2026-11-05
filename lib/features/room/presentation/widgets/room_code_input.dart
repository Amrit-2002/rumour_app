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
      children: [
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.secondarySurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? AppColors.errorAccent
                  : AppColors.borderLight,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            enabled: enabled,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textAlign: TextAlign.center,
            autofocus: false,
            maxLength: 6,
            buildCounter: (
              BuildContext context, {
              required int currentLength,
              required bool isFocused,
              required int? maxLength,
            }) => null,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(6),
              _UpperCaseTextFormatter(),
            ],
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 8.0,
              fontFamily: 'monospace',
            ),
            decoration: const InputDecoration(
              hintText: '••••••',
              hintStyle: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 8.0,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
          ),
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

