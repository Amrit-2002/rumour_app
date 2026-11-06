import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/input_validator.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_key_logo.dart';
import '../providers/room_provider.dart';
import '../widgets/room_code_input.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isJoinEnabled = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    final text = _codeController.text.trim();
    final bool canJoin = text.length == AppConstants.roomCodeLength;
    if (_isJoinEnabled != canJoin || _localError != null) {
      setState(() {
        _isJoinEnabled = canJoin;
        _localError = null;
      });
      context.read<RoomProvider?>()?.clearError();
    }
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoinRoom([String? customCode]) async {
    final code = (customCode ?? _codeController.text).trim().toUpperCase();
    final validationError = InputValidator.validateRoomCode(code);
    if (validationError != null) {
      setState(() {
        _localError = validationError;
      });
      return;
    }

    final roomProvider = context.read<RoomProvider?>();
    if (roomProvider == null) {
      // Fallback for tests without Provider tree
      Navigator.pushNamed(
        context,
        AppRoutes.identityReveal,
        arguments: IdentityRevealArgs(roomCode: code),
      );
      return;
    }

    final success = await roomProvider.joinRoom(code);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.identityReveal,
        arguments: IdentityRevealArgs(roomCode: code),
      );
    }
  }

  Future<void> _handleCreateRoom() async {
    final roomProvider = context.read<RoomProvider?>();
    final authService = context.read<AuthService?>();

    if (roomProvider == null) {
      // Fallback for tests without Provider tree
      Navigator.pushNamed(
        context,
        AppRoutes.identityReveal,
        arguments: const IdentityRevealArgs(roomCode: '581290'),
      );
      return;
    }

    String uid = authService?.currentUid ?? '';
    if (uid.isEmpty && authService != null) {
      try {
        uid = await authService.getOrEnsureUid();
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _localError =
              'Authentication failed. Please check your internet connection.';
        });
        return;
      }
    }

    if (uid.isEmpty) {
      if (!mounted) return;
      setState(() {
        _localError = 'Authentication required to create room.';
      });
      return;
    }

    final code = await roomProvider.createRoom(uid);
    if (!mounted) return;

    if (code != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.identityReveal,
        arguments: IdentityRevealArgs(roomCode: code),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider?>();
    final isLoading = roomProvider?.isLoading ?? false;
    final errorMessage = _localError ?? roomProvider?.errorMessage;

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
                      const Center(
                        child: AppKeyLogo(
                          key: Key('app_logo_badge'),
                          size: 58,
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
                        enabled: !isLoading,
                        errorText: errorMessage,
                        onSubmitted: (code) {
                          if (code.length == AppConstants.roomCodeLength && !isLoading) {
                            _handleJoinRoom(code);
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Join Room CTA
                      AppButton(
                        text: 'Join Room',
                        isLoading: isLoading,
                        onPressed: (_isJoinEnabled && !isLoading)
                            ? () => _handleJoinRoom()
                            : null,
                      ),
                      const SizedBox(height: 18),

                      // Create Room Secondary Action
                      AppButton.outline(
                        text: 'Create New Room',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _handleCreateRoom,
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
