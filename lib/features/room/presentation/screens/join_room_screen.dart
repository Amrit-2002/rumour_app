import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/room_code_input.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isJoinEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    final text = _codeController.text.trim();
    final bool canJoin = text.length == AppConstants.roomCodeLength;
    if (_isJoinEnabled != canJoin || _errorMessage != null) {
      setState(() {
        _isJoinEnabled = canJoin;
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  void _handleJoinRoom([String? customCode]) {
    final code = (customCode ?? _codeController.text).trim().toUpperCase();
    if (code.length != AppConstants.roomCodeLength) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit room code';
      });
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.identityReveal,
      arguments: IdentityRevealArgs(roomCode: code),
    );
  }

  void _handleCreateRoom() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      const mockCode = '581290';
      Navigator.pushNamed(
        context,
        AppRoutes.identityReveal,
        arguments: const IdentityRevealArgs(roomCode: mockCode),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),

                      // Figma Top Key Icon Badge
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondarySurface,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.key_rounded,
                            size: 28,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title matching Figma
                      const Text(
                        'Join A Room',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle matching Figma
                      const Text(
                        'Enter the code to join the anon chat room',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),

                      // 6-digit Slot Input Box
                      RoomCodeInput(
                        controller: _codeController,
                        errorText: _errorMessage,
                        onSubmitted: (code) {
                          if (code.length == AppConstants.roomCodeLength) {
                            _handleJoinRoom(code);
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Join Room CTA
                      AppButton(
                        text: 'Join Room',
                        onPressed: _isJoinEnabled ? () => _handleJoinRoom() : null,
                      ),
                      const SizedBox(height: 18),

                      // Create Room Secondary Action
                      AppButton.outline(
                        text: 'Create New Room',
                        isLoading: _isLoading,
                        onPressed: _handleCreateRoom,
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
