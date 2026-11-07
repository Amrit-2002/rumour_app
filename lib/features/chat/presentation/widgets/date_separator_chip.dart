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
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: colors.dateChipBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.borderLight,
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

