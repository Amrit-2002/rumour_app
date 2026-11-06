import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  final String message;

  const OfflineBanner({
    super.key,
    this.message = 'Offline mode — messages will sync when reconnected',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      color: AppColors.secondarySurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: AppColors.syncPending,
            size: 14,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.syncPending,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

