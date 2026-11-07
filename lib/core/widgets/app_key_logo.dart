import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Renders the official Rumour key logo matching the Figma design and brand asset.
/// Uses the clean asset with a custom vector painter fallback for test reliability.
class AppKeyLogo extends StatelessWidget {
  final double size;
  final bool showBackgroundCircle;

  const AppKeyLogo({
    super.key,
    this.size = 58.0,
    this.showBackgroundCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final double keyWidth = size * 0.54;
    final double keyHeight = keyWidth * (150.0 / 286.0);

    final Widget logoContent = SizedBox(
      width: keyWidth,
      height: keyHeight,
      child: Image.asset(
        'assets/images/key_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(
            size: Size(keyWidth, keyHeight),
            painter: _KeyLogoPainter(color: colors.primaryAccent),
          );
        },
      ),
    );

    if (!showBackgroundCircle) {
      return logoContent;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.badgeSurface,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.borderLight,
          width: 1.2,
        ),
      ),
      child: Center(
        child: logoContent,
      ),
    );
  }
}

class _KeyLogoPainter extends CustomPainter {
  final Color color;

  _KeyLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Base coordinate space: 286 x 150
    final double scaleX = size.width / 286.0;
    final double scaleY = size.height / 150.0;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    // 1. Center dot inside key head
    canvas.drawCircle(const Offset(75, 75), 25, fillPaint);

    // 2. Outer key path: outer ring + shaft with pointed chevron tip and teeth
    final Path outerPath = Path();
    // Arc for left outer circle (center 75, 75, radius 75)
    outerPath.arcTo(
      const Rect.fromLTWH(0, 0, 150, 150),
      0.55 * 3.14159,
      1.9 * 3.14159,
      false,
    );
    // Top shaft line to arrow tip
    outerPath.lineTo(245, 37);
    outerPath.lineTo(285, 75); // Arrow tip
    // Bottom teeth back to head
    outerPath.lineTo(245, 115);
    outerPath.lineTo(230, 125);
    outerPath.lineTo(215, 119);
    outerPath.lineTo(195, 119);
    outerPath.lineTo(180, 127);
    outerPath.lineTo(165, 120);
    outerPath.lineTo(145, 112);
    outerPath.close();

    // 3. Inner gap cutout in key head (radius 49 circle) and inner shaft notch
    final Path cutouts = Path();
    cutouts.addOval(const Rect.fromLTWH(26, 26, 98, 98));

    // Inner shaft channel cutout
    final Path channel = Path()
      ..moveTo(100, 63)
      ..lineTo(235, 63)
      ..lineTo(240, 75)
      ..lineTo(235, 86)
      ..lineTo(100, 86)
      ..close();
    cutouts.addPath(channel, Offset.zero);

    // Combine using difference
    final Path keyBody = Path.combine(
      PathOperation.difference,
      outerPath,
      cutouts,
    );

    canvas.drawPath(keyBody, fillPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KeyLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}

