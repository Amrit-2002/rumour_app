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

  void _handleJoinRoom() {
    final code = _codeController.text.trim().toUpperCase();
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

    // Mock room creation for Milestone 2 UI demonstration
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Deterministic sample mock room code
      const mockCode = 'RM7K29';
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      // Brand Icon Header
                      Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryAccent.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withValues(alpha: 0.12),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.forum_rounded,
                            size: 34,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Brand Titles
                      const Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ephemeral anonymous group chat.\nNo sign-up. No tracking.',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Room Code Input Box
                      RoomCodeInput(
                        controller: _codeController,
                        errorText: _errorMessage,
                        onSubmitted: (_) {
                          if (_isJoinEnabled) _handleJoinRoom();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Join Room CTA
                      AppButton(
                        text: 'Join Room',
                        onPressed: _isJoinEnabled ? _handleJoinRoom : null,
                      ),
                      const SizedBox(height: 24),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.borderLight,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.borderLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Create Room Action
                      AppButton.outline(
                        text: 'Create New Room',
                        isLoading: _isLoading,
                        icon: Icons.add_rounded,
                        onPressed: _handleCreateRoom,
                      ),
                      const Spacer(),

                      // Footer Note
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: AppColors.secondaryText.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Identities are generated anonymously per room',
                            style: TextStyle(
                              color: AppColors.secondaryText.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

