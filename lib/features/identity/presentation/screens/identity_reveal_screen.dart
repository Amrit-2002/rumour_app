import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/identity_provider.dart';

class IdentityRevealScreen extends StatefulWidget {
  final String roomCode;
  final String? initialAdjective;
  final String? initialAnimal;

  const IdentityRevealScreen({
    super.key,
    required this.roomCode,
    this.initialAdjective,
    this.initialAnimal,
  });

  @override
  State<IdentityRevealScreen> createState() => _IdentityRevealScreenState();
}

class _IdentityRevealScreenState extends State<IdentityRevealScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final identityProvider = context.read<IdentityProvider?>();
      if (identityProvider != null) {
        final authService = context.read<AuthService?>();
        final uid = authService?.currentUid ?? 'device_uid';
        identityProvider.resolveIdentity(
          roomCode: widget.roomCode,
          uid: uid,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final identityProvider = context.watch<IdentityProvider?>();
    final identity = identityProvider?.currentIdentity;
    final isLoading = identityProvider?.isLoading ?? false;

    final adjective = identity?.adjective ?? widget.initialAdjective ?? 'Brave';
    final animal = identity?.animal ?? widget.initialAnimal ?? 'Badger';
    final isRestored = identity?.isRestored ?? false;
    final fullUsername = '$adjective $animal';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pop(context),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Prominent Identity Card matching Figma
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.secondarySurface,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isRestored ? 'Welcome back! For this room you are' : 'For this room you are',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Big 2-line Neon Lime Persona Name
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      )
                    else
                      Text(
                        '$adjective\n$animal',
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 24),

                    // Privacy note inside card
                    Text(
                      isRestored
                          ? 'Your previous anonymous identity for this room was restored from this device.'
                          : 'This is your anonymous identity, visible only to users in this room.',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Figma CTA: "Acknowledge and continue"
              AppButton(
                text: 'Acknowledge and continue',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.chat,
                          arguments: ChatArgs(
                            roomCode: widget.roomCode,
                            username: fullUsername,
                          ),
                        );
                      },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
