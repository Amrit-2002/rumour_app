import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/app_button.dart';

class IdentityRevealScreen extends StatelessWidget {
  final String roomCode;
  final String adjective;
  final String animal;

  const IdentityRevealScreen({
    super.key,
    required this.roomCode,
    this.adjective = 'Brave',
    this.animal = 'Badger',
  });

  String get fullUsername => '$adjective $animal';

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
              'Room #$roomCode',
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
                    const Text(
                      'For this room you are',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Big 2-line Neon Lime Persona Name
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
                    const Text(
                      'This is your anonymous identity, visible only to users in this room.',
                      style: TextStyle(
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
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.chat,
                    arguments: ChatArgs(
                      roomCode: roomCode,
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
