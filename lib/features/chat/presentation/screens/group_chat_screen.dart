import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // Reversed list: index 0 is the newest message
    _messages = [
      _MockMessage(
        id: '5',
        senderName: widget.username,
        text: "Testing out the new anonymous room! Let's share some rumours.",
        time: 'Just now',
        isMe: true,
        isPending: true,
      ),
      const _MockMessage(
        id: '4',
        senderName: 'Cosmic Otter',
        text: 'Welcome everyone! Identities are fully anonymous here.',
        time: '19:32',
        isMe: false,
      ),
      const _MockMessage(
        id: '3',
        senderName: 'Velvet Badger',
        text: 'Did anyone test the offline sync yet?',
        time: '19:30',
        isMe: false,
      ),
      _MockMessage(
        id: '2',
        senderName: widget.username,
        text: 'Offline caching works automatically via Firestore persistence.',
        time: '19:28',
        isMe: true,
      ),
      const _MockMessage(
        id: '1',
        senderName: 'Silent Wolf',
        text: 'Room created. Welcome to Rumour!',
        time: '19:25',
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
          time: 'Just now',
          isMe: true,
        ),
      );
    });
  }

  void _copyRoomCode() {
    Clipboard.setData(ClipboardData(text: widget.roomCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room code #${widget.roomCode} copied to clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
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
          'You can re-enter room #${widget.roomCode} anytime using this code. Your persona (${widget.username}) will be saved on this device.',
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
              Navigator.pop(dialogContext); // Close dialog
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
        titleSpacing: 0,
        title: InkWell(
          onTap: _copyRoomCode,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Room #${widget.roomCode}',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: AppColors.primaryAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'as ${widget.username}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Leave Room',
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.secondaryText,
              size: 22,
            ),
            onPressed: _confirmLeaveRoom,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat message feed
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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

          // Pinned bottom input bar
          ChatInputBar(
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}

