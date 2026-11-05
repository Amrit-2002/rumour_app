import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/app_button.dart';

class IdentityRevealScreen extends StatelessWidget {
  final String roomCode;
  final String mockPersona;

  const IdentityRevealScreen({
    super.key,
    required this.roomCode,
    this.mockPersona = 'Neon Falcon',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Hero Persona Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryAccent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 46,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Persona Header
              const Text(
                'YOU ARE JOINING AS',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mockPersona,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Room Code Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondarySurface, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tag_rounded,
                      size: 14,
                      color: AppColors.primaryAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Room #$roomCode',
                      style: const TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Explanatory Persistence Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondarySurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.primaryAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Room-Scoped Persona',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This identity is saved locally. If you leave and rejoin this room later, this persona will be restored.',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Enter Chat CTA
              AppButton(
                text: 'Enter Chat Room',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.chat,
                    arguments: ChatArgs(
                      roomCode: roomCode,
                      username: mockPersona,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

