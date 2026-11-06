import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/navigation.dart';
import '../../domain/models/message_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class GroupChatScreen extends StatefulWidget {
  final String roomCode;
  final String username;

  const GroupChatScreen({
    super.key,
    required this.roomCode,
    required this.username,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late final List<MessageModel> _fallbackMessages;

  @override
  void initState() {
    super.initState();
    _fallbackMessages = [
      MessageModel(
        id: '1',
        senderId: 'sample_other',
        senderName: 'Wild Panther',
        text: 'Hello! glad to join you guys. I have a few ideas',
        createdAt: DateTime.now(),
      ),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider?>();
      if (chatProvider != null) {
        final authService = context.read<AuthService?>();
        final uid = authService?.currentUid ?? 'anon_user';
        chatProvider.enterRoom(
          roomCode: widget.roomCode,
          uid: uid,
          username: widget.username,
        );
      }
    });
  }

  void _handleSendMessage(String text) {
    final chatProvider = context.read<ChatProvider?>();
    final authService = context.read<AuthService?>();
    final uid = authService?.currentUid ?? 'anon_user';

    if (chatProvider != null) {
      chatProvider.sendMessage(
        roomCode: widget.roomCode,
        text: text,
        senderId: uid,
        senderName: widget.username,
      );
    } else {
      // Standalone test fallback
      setState(() {
        _fallbackMessages.insert(
          0,
          MessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: uid,
            senderName: widget.username,
            text: text,
            createdAt: DateTime.now(),
          ),
        );
      });
    }
  }

  void _confirmLeaveRoom() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Leave Room?',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'You can re-enter room #${widget.roomCode} anytime. Your identity (${widget.username}) is preserved on this device.',
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 40),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatProvider?>()?.leaveRoom();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.joinRoom,
                (route) => false,
              );
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider?>();
    final authService = context.watch<AuthService?>();
    final currentUid = authService?.currentUid ?? '';

    final messages = chatProvider?.messages ?? _fallbackMessages;
    final isSending = chatProvider?.isSending ?? false;
    final errorMessage = chatProvider?.errorMessage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _confirmLeaveRoom,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.secondarySurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.primaryText,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Room #${widget.roomCode}',
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              '1 members',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.secondarySurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.primaryText,
                    size: 20,
                  ),
                  onPressed: _confirmLeaveRoom,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Centered Date Chip matching Figma ("Today")
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: AppColors.secondarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Error banner if any
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorAccent.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.errorAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: AppColors.errorAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          // Real-time message feed
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'No rumours yet.\nBe the first to share one!',
                      style: TextStyle(
                        color: AppColors.secondaryText.withValues(alpha: 0.6),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = (currentUid.isNotEmpty && message.senderId == currentUid) ||
                          message.senderName == widget.username;

                      return ChatBubble(
                        text: message.text,
                        senderName: message.senderName,
                        time: _formatTime(message.createdAt),
                        isMe: isMe,
                        isPending: message.isPending,
                      );
                    },
                  ),
          ),

          // Pinned bottom input bar matching Figma
          ChatInputBar(
            isSending: isSending,
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}
