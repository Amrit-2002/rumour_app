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
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Label above bubble matching Figma ("You" or "@SenderName")
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
              child: Text(
                isMe ? 'You' : '@$senderName',
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      
          // Message Container
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isMe ? AppColors.bubbleSent : AppColors.bubbleReceived,
              borderRadius: BorderRadius.circular(16),
              border: isMe
                  ? null
                  : Border.all(color: AppColors.borderLight, width: 0.8),
            ),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 8.0,
              runSpacing: 2.0,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isMe ? AppColors.darkText : AppColors.primaryText,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
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
                        const SizedBox(width: 3),
                        Icon(
                          isPending
                              ? Icons.schedule_rounded
                              : Icons.done_all_rounded,
                          size: 11,
                          color: isPending
                              ? AppColors.darkText.withValues(alpha: 0.65)
                              : AppColors.darkText,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
