import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/navigation.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class _MockMessage {
  final String id;
  final String senderName;
  final String text;
  final String time;
  final bool isMe;
  final bool isPending;

  const _MockMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
    this.isPending = false,
  });
}

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
  late final List<_MockMessage> _messages;

  @override
  void initState() {
    super.initState();
    // Reversed list matching Figma chat design
    _messages = [
      _MockMessage(
        id: '2',
        senderName: widget.username,
        text: 'Hello! glad to join you guys. I have a few ideas',
        time: '10:15',
        isMe: true,
        isPending: false,
      ),
      const _MockMessage(
        id: '1',
        senderName: 'Wild Panther',
        text: 'Hi all! come to this room to discuss the project and suggest cool apps or anything with teams.',
        time: '10:14',
        isMe: false,
      ),
    ];
  }

  void _handleSendMessage(String text) {
    setState(() {
      _messages.insert(
        0,
        _MockMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: widget.username,
          text: text,
          time: '10:16',
          isMe: true,
          isPending: false,
        ),
      );
    });
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

          // Message feed
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  text: message.text,
                  senderName: message.senderName,
                  time: message.time,
                  isMe: message.isMe,
                  isPending: message.isPending,
                );
              },
            ),
          ),

          // Pinned bottom input bar matching Figma
          ChatInputBar(
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}
