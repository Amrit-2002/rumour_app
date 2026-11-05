import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String senderName;
  final String time;
  final bool isMe;
  final bool isPending;

  const ChatBubble({
    super.key,
    required this.text,
    required this.senderName,
    required this.time,
    required this.isMe,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.76;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryAccent : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe
              ? null
              : Border.all(color: AppColors.secondarySurface, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sender name (only shown on other people's messages)
            if (!isMe) ...[
              Text(
                senderName,
                style: const TextStyle(
                  color: AppColors.primaryAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
            ],

            // Message text
            Text(
              text,
              style: TextStyle(
                color: isMe ? AppColors.darkText : AppColors.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),

            // Time & Status row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isMe
                        ? AppColors.darkText.withValues(alpha: 0.65)
                        : AppColors.secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isPending
                        ? Icons.schedule_rounded
                        : Icons.done_all_rounded,
                    size: 13,
                    color: isPending
                        ? AppColors.darkText.withValues(alpha: 0.65)
                        : AppColors.darkText,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

