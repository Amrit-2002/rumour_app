import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isSending = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasContent = _textController.text.trim().isNotEmpty;
    if (_canSend != hasContent) {
      setState(() => _canSend = hasContent);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty || widget.isSending) return;

    widget.onSend(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.secondarySurface, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: AppColors.secondarySurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  maxLength: AppConstants.maxMessageLength,
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) => null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a rumour...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    isDense: true,
                    filled: false,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: _canSend && !widget.isSending
                    ? AppColors.primaryAccent
                    : AppColors.secondarySurface,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: widget.isSending
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.darkText,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_upward_rounded,
                        color: _canSend
                            ? AppColors.darkText
                            : AppColors.secondaryText,
                        size: 22,
                      ),
                onPressed: _canSend && !widget.isSending ? _handleSend : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

