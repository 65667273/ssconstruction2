// ===== Section Title (assumed from your code) =====
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class AnimatedRevealWidget extends StatelessWidget {
  final Widget child;
  final bool visible;
  final int delay;

  const AnimatedRevealWidget({
    super.key,
    required this.child,
    required this.visible,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: visible ? 1.0 : 0.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
          ),
        );
      },
    );
  }
}

class AnimatedBackgroundPainter extends CustomPainter {
  final double animationValue;

  AnimatedBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // Animated grid lines
    for (int i = 0; i < 10; i++) {
      final offset = (animationValue * size.height) % (size.height / 10);
      final y = (i * size.height / 10) + offset;

      paint
        ..color = const Color(0xFFFAAB0C).withOpacity(0.03)
        ..strokeWidth = 1;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Animated diagonal lines
    for (int i = 0; i < 20; i++) {
      final offset = (animationValue * size.width * 2) % (size.width * 2);
      final x = (i * size.width / 10) + offset - size.width;

      paint
        ..color = Colors.yellow.withOpacity(0.02)
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AnimatedBackgroundPainter oldDelegate) => true;
}

class MachineItem {
  final IconData icon;
  final String name;
  final String quantity;

  MachineItem({required this.icon, required this.name, required this.quantity});
}
