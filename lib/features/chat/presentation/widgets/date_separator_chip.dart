import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';

class DateSeparatorChip extends StatelessWidget {
  final DateTime date;

  const DateSeparatorChip({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormatter.formatDateHeader(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: AppColors.secondarySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

