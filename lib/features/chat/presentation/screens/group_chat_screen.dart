import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/navigation.dart';
import '../../domain/models/message_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/date_separator_chip.dart';
import '../widgets/offline_banner.dart';

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
  final ScrollController _scrollController = ScrollController();

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

    _scrollController.addListener(_onScroll);

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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final chatProvider = context.read<ChatProvider?>();
      if (chatProvider != null &&
          !chatProvider.isLoadingMore &&
          chatProvider.hasMore) {
        chatProvider.fetchOlderMessages(widget.roomCode);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider?>();
    final authService = context.watch<AuthService?>();
    final currentUid = authService?.currentUid ?? '';

    final messages = chatProvider?.messages ?? _fallbackMessages;
    final isSending = chatProvider?.isSending ?? false;
    final isLoadingMore = chatProvider?.isLoadingMore ?? false;
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
          // Offline status banner if reading from cache or writes are queued
          if (chatProvider?.isFromCache == true ||
              chatProvider?.hasPendingWrites == true)
            const OfflineBanner(),

          // Error banner if any
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.errorAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.errorAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.errorAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: AppColors.errorAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Real-time message feed with dynamic date separators and pagination
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
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    itemCount: messages.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Top loading indicator when paginating older messages
                      if (isLoadingMore && index == messages.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        );
                      }

                      final message = messages[index];
                      final isMe = (currentUid.isNotEmpty &&
                              message.senderId == currentUid) ||
                          message.senderName == widget.username;

                      // Check if a date chip should be displayed above this message
                      final bool showDateChip = (index == messages.length - 1) ||
                          !DateFormatter.isSameDay(
                            message.createdAt,
                            messages[index + 1].createdAt,
                          );

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showDateChip)
                            DateSeparatorChip(date: message.createdAt),
                          ChatBubble(
                            text: message.text,
                            senderName: message.senderName,
                            time: DateFormatter.formatTime(message.createdAt),
                            isMe: isMe,
                            isPending: message.isPending,
                          ),
                        ],
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
