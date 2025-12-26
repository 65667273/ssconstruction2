import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ss/landing.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SSConstructionCinematicApp());
}

class SSConstructionCinematicApp extends StatelessWidget {
  const SSConstructionCinematicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SS Construction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFFAAB0C),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final isMobile = size.width < 600;
          final isTablet = size.width >= 600 && size.width < 900;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: ModernLandingPage()),
          );
        },
      ),
    );
  }
}

// ===== Background & Particles =====
class AnimatedBackground extends StatelessWidget {
  final AnimationController controller;
  const AnimatedBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final v = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.9 + v * 0.5, -1),
              end: Alignment(0.9 - v * 0.5, 1),
              colors: [
                const Color(0xFF050505),
                const Color(0xFF0F0F10).withOpacity(0.95),
                const Color(0xFF111111).withOpacity(0.88),
                const Color(0xFF0A0A0A).withOpacity(0.88),
              ],
              stops: const [0.0, 0.45, 0.75, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class HeroSpotlight extends StatelessWidget {
  final AnimationController controller;
  const HeroSpotlight({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final v = controller.value;
        final radius = 0.32 + 0.08 * sin(v * 2 * pi);
        final alpha = 0.06 + 0.04 * (0.5 + 0.5 * sin(v * 2 * pi));
        return IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.1 + 0.2 * sin(v * 2 * pi), -0.1),
                radius: radius,
                colors: [Colors.yellow.withOpacity(alpha), Colors.transparent],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ParticleSweep extends StatelessWidget {
  final AnimationController controller;
  const ParticleSweep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ParticlePainter(progress: controller.value),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final _rng = Random(1234);
  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final count = 28;
    for (var i = 0; i < count; i++) {
      final t = (i / count + progress) % 1.0;
      final x = lerpDouble(-size.width * 0.15, size.width * 1.15, t)!;
      final y = size.height * (0.25 + 0.5 * _seedSin(i * 7 + progress * 6));
      final base = 2.0 + 5.0 * _seedSin(i * 13 + progress * 3).abs();
      final opacity = 0.06 + 0.08 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(opacity * 0.9);
      final r = base;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  double _seedSin(double v) => sin(v + 0.5);

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress;
}

// ===== Optimized Fast-Loading Hero Text Block =====
class HeroTextBlock extends StatefulWidget {
  final AnimationController introController;
  const HeroTextBlock({super.key, required this.introController});

  @override
  State<HeroTextBlock> createState() => _HeroTextBlockState();
}

class _HeroTextBlockState extends State<HeroTextBlock> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.introController,
      builder: (context, _) {
        final v = Curves.easeOutCubic.transform(widget.introController.value);

        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(-20 * (1 - v), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Headline - simple fade + slide
                _buildHeadline(context, v),
                const SizedBox(height: 15),

                // Subtitle with delay
                if (v > 0.3) _buildSubtitle(context, (v - 0.3) / 0.7),
                const SizedBox(height: 24),

                // CTA Buttons with delay
                if (v > 0.5) _buildCTAButtons(context, (v - 0.5) / 0.5),
                const SizedBox(height: 18),

                // Info Badges with delay
                if (v > 0.6) _buildInfoBadges(context, (v - 0.6) / 0.4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeadline(BuildContext context, double v) {
    return Transform.scale(
      scale: 0.95 + (0.05 * v),
      alignment: Alignment.centerLeft,
      child: Text(
        'SS Construction',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontSize: 45,
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
          shadows: [
            Shadow(
              color: const Color(0xFFFAAB0C).withOpacity(0.3 * v),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, double v) {
    return Opacity(
      opacity: v,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - v)),
        child: Container(
          padding: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: const Color(0xFFFAAB0C).withOpacity(v),
                width: 3,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              'Building Strong Roads. Developing sanctioned layouts. Creating tomorrow\'s infrastructure.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCTAButtons(BuildContext context, double v) {
    return Opacity(
      opacity: v,
      child: Transform.translate(
        offset: Offset(0, 15 * (1 - v)),
        child: Row(
          children: [
            _FastButton(label: 'Our Projects', filled: true),
            const SizedBox(width: 16),
            _FastButton(label: 'Book Site Visit', filled: false),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadges(BuildContext context, double v) {
    return Opacity(
      opacity: v,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - v)),
        child: Row(
          children: [
            InfoBadge(
              icon: Icons.engineering,
              label: 'Government Works',
              animationValue: v,
            ),
            const SizedBox(width: 12),
            InfoBadge(
              icon: Icons.precision_manufacturing,
              label: 'Own Fleet',
              animationValue: v,
            ),
          ],
        ),
      ),
    );
  }
}

// Simplified button with fast hover effect
class _FastButton extends StatefulWidget {
  final String label;
  final bool filled;

  const _FastButton({required this.label, required this.filled});

  @override
  State<_FastButton> createState() => _FastButtonState();
}

class _FastButtonState extends State<_FastButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -3.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.filled
                          ? const Color(0xFFFAAB0C).withOpacity(0.4)
                          : Colors.white.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.filled
                  ? const Color(0xFFFAAB0C)
                  : Colors.white.withOpacity(_isHovered ? 0.1 : 0.05),
              foregroundColor: widget.filled ? Colors.black : Colors.white,
              side: widget.filled
                  ? null
                  : BorderSide(
                      color: Colors.white.withOpacity(_isHovered ? 0.6 : 0.3),
                      width: 2,
                    ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isHovered ? 8 : 0,
                ),
                if (_isHovered) const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoBadge extends StatefulWidget {
  final IconData icon;
  final String label;
  final double animationValue;

  const InfoBadge({
    super.key,
    required this.icon,
    required this.label,
    this.animationValue = 1.0,
  });

  @override
  State<InfoBadge> createState() => _InfoBadgeState();
}

class _InfoBadgeState extends State<InfoBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isHovered ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFFAAB0C).withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFAAB0C).withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()..rotateZ(_isHovered ? 0.1 : 0.0),
              child: Icon(
                widget.icon,
                size: 18,
                color: const Color(0xFFFAAB0C),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.white70,
                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedReveal extends StatelessWidget {
  final Widget child;
  final bool visible;
  final int delayMs;
  const AnimatedReveal({
    super.key,
    required this.child,
    required this.visible,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: visible ? 1.0 : 0.0),
      duration: Duration(milliseconds: 700 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: Transform.scale(scale: 0.95 + (0.05 * value), child: child),
          ),
        );
      },
    );
  }
}

// ===== Sections =====
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  const SectionContainer({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: child,
        ),
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

class QualityStandardsSection extends StatefulWidget {
  const QualityStandardsSection({super.key});

  @override
  State<QualityStandardsSection> createState() =>
      _QualityStandardsSectionState();
}

class _QualityStandardsSectionState extends State<QualityStandardsSection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _progressController;
  bool _isVisible = false;

  final List<MaterialData> materials = [
    MaterialData(
      icon: Icons.layers,
      name: 'Cement',
      brands: 'UltraTech, ACC, Ambuja',
      grade: 'M30/M35 Grade',
      color: const Color(0xFF6B7280),
    ),
    MaterialData(
      icon: Icons.grain,
      name: 'Gitti (Aggregate)',
      brands: '20mm/40mm',
      grade: 'IS-Standard Crushed',
      color: const Color(0xFF94A3B8),
    ),
    MaterialData(
      icon: Icons.water_drop,
      name: 'Reti (Sand)',
      brands: 'River Sand',
      grade: 'Clean & Screened',
      color: const Color(0xFFD97706),
    ),
    MaterialData(
      icon: Icons.architecture,
      name: 'Loha (Steel)',
      brands: 'TMT Bars',
      grade: 'Fe-500/Fe-550 Grade',
      color: const Color(0xFF991B1B),
    ),
    MaterialData(
      icon: Icons.grid_on,
      name: 'Paver Blocks',
      brands: 'ISI Approved',
      grade: 'Premium Quality',
      color: const Color(0xFF0369A1),
    ),
  ];

  final List<InspectionStage> inspectionStages = [
    InspectionStage(name: 'Soil Compaction', progress: 0.95),
    InspectionStage(name: 'Foundation Check', progress: 0.98),
    InspectionStage(name: 'Material Testing', progress: 1.0),
    InspectionStage(name: 'Structure Integrity', progress: 0.97),
    InspectionStage(name: 'Final Curing', progress: 0.99),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF1A1A1A),
            const Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 70),
                    _buildMaterialsGrid(),
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: _buildInspectionProcess(),
                    ),
                    const SizedBox(height: 60),
                    _buildQualityBadge(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: QualityBackgroundPainter(
              animationValue: _backgroundController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFAAB0C), Colors.yellow.shade700],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFAAB0C).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quality Standards',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.5,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFAAB0C).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAAB0C), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: const Color(0xFFFAAB0C).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Strictly following high-grade materials and testing protocols',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1200;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: List.generate(
            materials.length,
            (index) => AnimatedRevealWidget(
              visible: _isVisible,
              delay: 200 + (index * 100),
              child: SizedBox(
                width: isWide ? 250 : 280,
                child: _MaterialCard(material: materials[index], index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInspectionProcess() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 800,
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFAAB0C).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAAB0C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFAAB0C),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.fact_check,
                    color: Color(0xFFFAAB0C),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Inspection Process',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ...List.generate(
              inspectionStages.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _InspectionBar(
                  stage: inspectionStages[index],
                  delay: 1000 + (index * 150),
                  animationController: _progressController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityBadge() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 1500,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFAAB0C).withOpacity(0.1),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFAAB0C).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              color: const Color(0xFFFAAB0C),
              size: 32,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                'Our quality team inspects each stage to ensure long-lasting infrastructure',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialCard extends StatefulWidget {
  final MaterialData material;
  final int index;

  const _MaterialCard({required this.material, required this.index});

  @override
  State<_MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<_MaterialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_isHovered ? 0.05 : 0)
          ..scale(_isHovered ? 1.05 : 1.0),
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.material.color.withOpacity(0.1),
                Colors.black.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? widget.material.color
                  : Colors.white.withOpacity(0.1),
              width: 2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.material.color.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Rotating background circle
              AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Positioned(
                    top: -50,
                    right: -50,
                    child: Transform.rotate(
                      angle: _rotateController.value * 2 * pi,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.material.color.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.material.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.material.color,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        widget.material.icon,
                        color: widget.material.color,
                        size: 36,
                      ),
                    ),

                    // Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.material.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.material.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.material.brands,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.material.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: const Color(0xFFFAAB0C),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.material.grade,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspectionBar extends StatelessWidget {
  final InspectionStage stage;
  final int delay;
  final AnimationController animationController;

  const _InspectionBar({
    required this.stage,
    required this.delay,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stage.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${(stage.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFAAB0C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final progress = Curves.easeOutCubic.transform(
                      animationController.value * value,
                    );

                    return Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          height: 12,
                          width:
                              MediaQuery.of(context).size.width *
                              stage.progress *
                              progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFAAB0C),
                                Colors.yellow.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFAAB0C).withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QualityBackgroundPainter extends CustomPainter {
  final double animationValue;

  QualityBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // Hexagonal grid pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        final x = i * 80.0;
        final y = j * 80.0 + (i % 2) * 40.0;

        final offset = (animationValue * 100) % 100;
        final opacity = (sin(animationValue * 2 * pi + i + j) + 1) / 2;

        paint
          ..color = const Color(0xFFFAAB0C).withOpacity(opacity * 0.05)
          ..strokeWidth = 1.5;

        _drawHexagon(canvas, Offset(x + offset, y), 30, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(QualityBackgroundPainter oldDelegate) => true;
}

class MaterialData {
  final IconData icon;
  final String name;
  final String brands;
  final String grade;
  final Color color;

  MaterialData({
    required this.icon,
    required this.name,
    required this.brands,
    required this.grade,
    required this.color,
  });
}

class InspectionStage {
  final String name;
  final double progress;

  InspectionStage({required this.name, required this.progress});
}

class TeamStrengthSection extends StatefulWidget {
  const TeamStrengthSection({super.key});

  @override
  State<TeamStrengthSection> createState() => _TeamStrengthSectionState();
}

class _TeamStrengthSectionState extends State<TeamStrengthSection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _counterController;
  late AnimationController _pulseController;
  bool _isVisible = false;

  final List<TeamMemberData> teamData = [
    TeamMemberData(
      icon: Icons.engineering,
      title: 'Skilled Laborers',
      count: 500,
      suffix: '+',
      description: 'Experienced workforce',
      color: const Color(0xFFFAAB0C),
      gradient: [const Color(0xFFFAAB0C), const Color(0xFFFFD700)],
    ),
    TeamMemberData(
      icon: Icons.engineering_outlined,
      title: 'Qualified Engineers',
      count: 10,
      suffix: '',
      description: 'Expert professionals',
      color: const Color(0xFF3B82F6),
      gradient: [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
    ),
    TeamMemberData(
      icon: Icons.supervisor_account,
      title: 'Site Supervisors',
      count: 15,
      suffix: '',
      description: 'On-ground management',
      color: const Color(0xFF10B981),
      gradient: [const Color(0xFF10B981), const Color(0xFF34D399)],
    ),
  ];

  final List<SupportFeature> supportFeatures = [
    SupportFeature(
      icon: Icons.local_shipping,
      title: 'Procurement',
      description: 'Efficient material sourcing',
    ),
    SupportFeature(
      icon: Icons.inventory_2,
      title: 'Logistics',
      description: 'Timely delivery system',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _counterController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _counterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0xFF0A0A0A),
            const Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 70),
                      _buildTeamStats(),
                      const SizedBox(height: 60),
                      _buildSupportSection(),
                      const SizedBox(height: 50),
                      _buildTotalStrength(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: TeamBackgroundPainter(
              animationValue: _backgroundController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedIcon(),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          const Color(0xFFFAAB0C),
                          Colors.white,
                          const Color(0xFFFAAB0C),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Team Strength',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  Container(
                    height: 4,
                    width: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAAB0C), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            'Powering excellence through skilled professionals',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white60,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (0.15 * _pulseController.value);
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFAAB0C), Colors.yellow.shade700],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFAAB0C,
                  ).withOpacity(0.4 + (0.3 * _pulseController.value)),
                  blurRadius: 30 + (20 * _pulseController.value),
                  spreadRadius: 5 + (5 * _pulseController.value),
                ),
              ],
            ),
            child: const Icon(Icons.groups, color: Colors.black, size: 40),
          ),
        );
      },
    );
  }

  Widget _buildTeamStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        return Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: List.generate(
            teamData.length,
            (index) => AnimatedRevealWidget(
              visible: _isVisible,
              delay: 200 + (index * 150),
              child: SizedBox(
                width: isWide ? 380 : 350,
                child: _TeamStatCard(
                  data: teamData[index],
                  index: index,
                  counterController: _counterController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportSection() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 800,
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFAAB0C).withOpacity(0.1),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFAAB0C).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.support_agent,
                  color: const Color(0xFFFAAB0C),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Strong Support Systems',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 30,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(
                supportFeatures.length,
                (index) =>
                    _SupportCard(feature: supportFeatures[index], index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStrength() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 1200,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFAAB0C), Colors.yellow.shade700],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFAAB0C,
                  ).withOpacity(0.4 + (0.2 * _pulseController.value)),
                  blurRadius: 30 + (10 * _pulseController.value),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.military_tech, color: Colors.black, size: 36),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Workforce',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '525+ Professionals',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TeamStatCard extends StatefulWidget {
  final TeamMemberData data;
  final int index;
  final AnimationController counterController;

  const _TeamStatCard({
    required this.data,
    required this.index,
    required this.counterController,
  });

  @override
  State<_TeamStatCard> createState() => _TeamStatCardState();
}

class _TeamStatCardState extends State<_TeamStatCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: Duration(milliseconds: 2500 + (widget.index * 300)),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final float = 8 * sin(_floatController.value * 2 * pi);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Transform.translate(
            offset: Offset(0, float),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_isHovered ? -0.08 : 0)
                ..scale(_isHovered ? 1.05 : 1.0),
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? [
                            widget.data.gradient[0].withOpacity(0.2),
                            widget.data.gradient[1].withOpacity(0.1),
                          ]
                        : [
                            Colors.white.withOpacity(0.05),
                            Colors.white.withOpacity(0.02),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? widget.data.color
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.data.color.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Stack(
                  children: [
                    // Animated circles background
                    Positioned(
                      top: -40,
                      right: -40,
                      child: AnimatedBuilder(
                        animation: _floatController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _floatController.value * 2 * pi,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    widget.data.color.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: widget.data.gradient,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.data.color.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.data.icon,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),

                          // Stats
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedBuilder(
                                animation: widget.counterController,
                                builder: (context, child) {
                                  final value = Curves.easeOutCubic.transform(
                                    widget.counterController.value,
                                  );
                                  final currentCount =
                                      (widget.data.count * value).toInt();

                                  return ShaderMask(
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                        colors: widget.data.gradient,
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      '$currentCount${widget.data.suffix}',
                                      style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1,
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.data.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.data.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SupportCard extends StatefulWidget {
  final SupportFeature feature;
  final int index;

  const _SupportCard({required this.feature, required this.index});

  @override
  State<_SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends State<_SupportCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0)
          ..scale(_isHovered ? 1.05 : 1.0),
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFFFAAB0C).withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFAAB0C).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAAB0C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.feature.icon,
                color: const Color(0xFFFAAB0C),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feature.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.feature.description,
                    style: TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamBackgroundPainter extends CustomPainter {
  final double animationValue;

  TeamBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // Animated connecting lines
    for (int i = 0; i < 15; i++) {
      final startX = (i * size.width / 15 + animationValue * 100) % size.width;
      final endX =
          ((i + 1) * size.width / 15 + animationValue * 100) % size.width;
      final y = sin(animationValue * 2 * pi + i) * 50 + size.height / 2;

      final opacity = (sin(animationValue * 2 * pi + i) + 1) / 2;

      paint
        ..color = const Color(0xFFFAAB0C).withOpacity(opacity * 0.1)
        ..strokeWidth = 2;

      canvas.drawLine(Offset(startX, y), Offset(endX, y + 50), paint);
    }

    // Network nodes
    for (int i = 0; i < 30; i++) {
      final x = (i * 50.0 + animationValue * 80) % size.width;
      final y =
          (sin(animationValue * 2 * pi + i * 0.5) * 100 + size.height / 2);
      final radius = 3 + sin(animationValue * 4 * pi + i) * 2;

      paint
        ..color = const Color(0xFFFAAB0C).withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(TeamBackgroundPainter oldDelegate) => true;
}

class TeamMemberData {
  final IconData icon;
  final String title;
  final int count;
  final String suffix;
  final String description;
  final Color color;
  final List<Color> gradient;

  TeamMemberData({
    required this.icon,
    required this.title,
    required this.count,
    required this.suffix,
    required this.description,
    required this.color,
    required this.gradient,
  });
}

class SupportFeature {
  final IconData icon;
  final String title;
  final String description;

  SupportFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class MediaGallerySection extends StatefulWidget {
  const MediaGallerySection({super.key});

  @override
  State<MediaGallerySection> createState() => _MediaGallerySectionState();
}

class _MediaGallerySectionState extends State<MediaGallerySection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _carouselController;
  bool _isVisible = false;
  int _selectedCategory = 0;

  final List<GalleryCategory> categories = [
    GalleryCategory(
      icon: Icons.photo_library,
      title: 'Photo Gallery',
      itemCount: 45,
      color: const Color(0xFFFAAB0C),
      items: [
        'Before & After Layouts',
        'Road Construction',
        'STP Installation',
        'Children\'s Parks',
        'Drone Aerial Views',
      ],
    ),
    GalleryCategory(
      icon: Icons.vrpano,
      title: '360° Virtual Tours',
      itemCount: 12,
      color: const Color(0xFF3B82F6),
      items: [
        'Layout Entrances',
        'Internal Roads',
        'Play Areas',
        'Plot Surroundings',
      ],
    ),
    GalleryCategory(
      icon: Icons.map,
      title: 'Interactive Maps',
      itemCount: 8,
      color: const Color(0xFF10B981),
      items: [
        'Digital Layout Plans',
        'Clickable Plots',
        'Size & Availability',
        'Booking Options',
      ],
    ),
    GalleryCategory(
      icon: Icons.videocam,
      title: 'Videos',
      itemCount: 20,
      color: const Color(0xFFEF4444),
      items: [
        'Construction Progress',
        'Machinery in Action',
        'Client Testimonials',
        'Project Walkthroughs',
      ],
    ),
  ];

  final List<SocialFeature> socialFeatures = [
    SocialFeature(
      icon: Icons.star,
      title: 'Google Reviews',
      value: '4.8',
      subtitle: '250+ Reviews',
      color: const Color(0xFFFAAB0C),
    ),
    SocialFeature(
      icon: Icons.camera_alt,
      title: 'Instagram',
      value: '5K+',
      subtitle: 'Followers',
      color: const Color(0xFFE4405F),
    ),
    SocialFeature(
      icon: Icons.play_circle,
      title: 'YouTube',
      value: '100+',
      subtitle: 'Videos',
      color: const Color(0xFFFF0000),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _carouselController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _carouselController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF000000),
            const Color(0xFF1A1A1A),
            const Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 60),
                      _buildCategoryTabs(),
                      const SizedBox(height: 50),
                      _buildSelectedCategory(),
                      const SizedBox(height: 70),
                      _buildSocialProof(),
                      const SizedBox(height: 50),
                      _buildCTASection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: MediaBackgroundPainter(
              animationValue: _backgroundController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedIcon(Icons.explore, const Color(0xFFFAAB0C)),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          const Color(0xFFFAAB0C),
                          Colors.white,
                          const Color(0xFFFAAB0C),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Explore Our Work',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  Container(
                    height: 4,
                    width: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAAB0C), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            'Discover our projects through photos, videos, and virtual tours',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final pulse = sin(_backgroundController.value * 2 * pi) * 0.15;
        return Transform.scale(
          scale: 1.0 + pulse,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5 + pulse),
                  blurRadius: 25 + (pulse * 20),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black, size: 40),
          ),
        );
      },
    );
  }

  Widget _buildCategoryTabs() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            categories.length,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _CategoryTab(
                category: categories[index],
                isSelected: _selectedCategory == index,
                onTap: () {
                  setState(() => _selectedCategory = index);
                  _carouselController.reset();
                  _carouselController.forward();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCategory() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _CategoryContent(
        key: ValueKey(_selectedCategory),
        category: categories[_selectedCategory],
        animationController: _carouselController,
      ),
    );
  }

  Widget _buildSocialProof() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 600,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thumb_up, color: const Color(0xFFFAAB0C), size: 28),

              Text(
                'Social Proof & Reviews',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: List.generate(
              socialFeatures.length,
              (index) =>
                  _SocialCard(feature: socialFeatures[index], index: index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 800,
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFAAB0C).withOpacity(0.15),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFFAAB0C).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Ready to Explore?',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Take a virtual tour or view our complete project gallery',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _ActionButton(
                  label: 'View Full Gallery',
                  icon: Icons.collections,
                  isPrimary: true,
                ),
                _ActionButton(
                  label: 'Start Virtual Tour',
                  icon: Icons.vrpano,
                  isPrimary: false,
                ),
                _ActionButton(
                  label: 'Watch Videos',
                  icon: Icons.play_circle,
                  isPrimary: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends StatefulWidget {
  final GalleryCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
                    colors: [
                      widget.category.color,
                      widget.category.color.withOpacity(0.8),
                    ],
                  )
                : null,
            color: widget.isSelected
                ? null
                : _isHovered
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: widget.isSelected
                  ? widget.category.color
                  : _isHovered
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.category.color.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.category.icon,
                color: widget.isSelected ? Colors.black : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.category.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: widget.isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.category.itemCount} items',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: widget.isSelected
                          ? Colors.black87
                          : Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryContent extends StatelessWidget {
  final GalleryCategory category;
  final AnimationController animationController;

  const _CategoryContent({
    super.key,
    required this.category,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [category.color.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: category.color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: category.color, width: 2),
                ),
                child: Icon(category.icon, color: category.color, size: 32),
              ),
              const SizedBox(width: 16),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(
              category.items.length,
              (index) => AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final delay = index * 0.1;
                  final value = Curves.easeOutCubic.transform(
                    ((animationController.value - delay).clamp(0.0, 1.0) /
                            (1 - delay))
                        .clamp(0.0, 1.0),
                  );

                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: _GalleryItem(
                        title: category.items[index],
                        color: category.color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryItem extends StatefulWidget {
  final String title;
  final Color color;

  const _GalleryItem({required this.title, required this.color});

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0)
          ..scale(_isHovered ? 1.05 : 1.0),
        width: 280,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isHovered
                ? [widget.color.withOpacity(0.2), widget.color.withOpacity(0.1)]
                : [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? widget.color : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Placeholder image overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
            // Play icon for videos
            if (widget.title.contains('Video') || widget.title.contains('Tour'))
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.black, size: 32),
                ),
              ),
            // Title
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialCard extends StatefulWidget {
  final SocialFeature feature;
  final int index;

  const _SocialCard({required this.feature, required this.index});

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500 + (widget.index * 200)),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -8.0 : 0.0)
              ..scale(_isHovered ? 1.05 : 1.0),
            width: 240,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.feature.color.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? widget.feature.color
                    : widget.feature.color.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.feature.color.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: widget.feature.color.withOpacity(
                          0.2 + (0.1 * _pulseController.value),
                        ),
                        blurRadius: 15 + (10 * _pulseController.value),
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: widget.feature.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.feature.color, width: 2),
                    ),
                    child: Icon(
                      widget.feature.icon,
                      color: widget.feature.color,
                      size: 26,
                    ),
                  ),

                  Text(
                    widget.feature.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: widget.feature.color,
                    ),
                  ),

                  Text(
                    widget.feature.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.feature.subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0)
          ..scale(_isHovered ? 1.05 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: _isHovered && widget.isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFFFAAB0C).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary
                ? const Color(0xFFFAAB0C)
                : Colors.white.withOpacity(_isHovered ? 0.15 : 0.08),
            foregroundColor: widget.isPrimary ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: widget.isPrimary
                ? null
                : BorderSide(
                    color: Colors.white.withOpacity(_isHovered ? 0.5 : 0.2),
                    width: 2,
                  ),
            elevation: 0,
          ),
          icon: Icon(widget.icon, size: 24),
          label: Text(
            widget.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class MediaBackgroundPainter extends CustomPainter {
  final double animationValue;

  MediaBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // Camera grid pattern
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        final x = i * size.width / 10 + (animationValue * 50) % 50;
        final y = j * size.height / 10;
        final opacity = (sin(animationValue * 2 * pi + i + j) + 1) / 2;

        paint
          ..color = const Color(0xFFFAAB0C).withOpacity(opacity * 0.05)
          ..strokeWidth = 1;

        canvas.drawRect(
          Rect.fromLTWH(x, y, size.width / 12, size.height / 12),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(MediaBackgroundPainter oldDelegate) => true;
}

class GalleryCategory {
  final IconData icon;
  final String title;
  final int itemCount;
  final Color color;
  final List<String> items;

  GalleryCategory({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.color,
    required this.items,
  });
}

class SocialFeature {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  SocialFeature({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });
}

// Data Models
class ChoiceFeature {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final Color accentColor;

  ChoiceFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.accentColor,
  });
}

// Main Section Widget
class WhyChooseSSSection extends StatefulWidget {
  const WhyChooseSSSection({super.key});

  @override
  State<WhyChooseSSSection> createState() => _WhyChooseSSSectionState();
}

class _WhyChooseSSSectionState extends State<WhyChooseSSSection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  bool _isVisible = false;

  final List<ChoiceFeature> features = [
    ChoiceFeature(
      icon: Icons.verified_user,
      title: 'NMRDA Sanctioned',
      description: 'Legally safe projects with government approval',
      gradient: [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
      accentColor: const Color(0xFF3B82F6),
    ),
    ChoiceFeature(
      icon: Icons.engineering,
      title: 'Experienced & Licensed Team',
      description: 'Expert contractor team with proven credentials',
      gradient: [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
      accentColor: const Color(0xFF8B5CF6),
    ),
    ChoiceFeature(
      icon: Icons.description,
      title: 'Transparent Documentation',
      description: 'Complete documentation & approvals available',
      gradient: [const Color(0xFF10B981), const Color(0xFF34D399)],
      accentColor: const Color(0xFF10B981),
    ),
    ChoiceFeature(
      icon: Icons.schedule,
      title: 'On-Time Delivery',
      description: 'Committed to meeting project deadlines',
      gradient: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
      accentColor: const Color(0xFFF59E0B),
    ),
    ChoiceFeature(
      icon: Icons.home_work,
      title: 'End-to-End Development',
      description: 'From raw land to ready-to-live layout',
      gradient: [const Color(0xFFEF4444), const Color(0xFFF87171)],
      accentColor: const Color(0xFFEF4444),
    ),
    ChoiceFeature(
      icon: Icons.construction,
      title: 'Own Fleet of Machinery',
      description: 'Faster work with dedicated equipment',
      gradient: [const Color(0xFF06B6D4), const Color(0xFF22D3EE)],
      accentColor: const Color(0xFF06B6D4),
    ),
    ChoiceFeature(
      icon: Icons.star,
      title: 'Quality-First Approach',
      description: 'Premium materials & construction standards',
      gradient: [const Color(0xFFFAAB0C), const Color(0xFFFFD700)],
      accentColor: const Color(0xFFFAAB0C),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      child: Stack(
        children: [
          _buildAnimatedBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 70),
                      _buildFeaturesGrid(),
                      const SizedBox(height: 60),
                      _buildCTASection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: ChoiceBackgroundPainter(
              animationValue: _backgroundController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 0,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -10 * _floatController.value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFAAB0C).withOpacity(0.2),
                    const Color(0xFFFAAB0C).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFFAAB0C).withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: const Text(
                'YOUR TRUSTED PARTNER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFAAB0C),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedIcon(),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Colors.white, Color(0xFFFAAB0C), Colors.white],
                        stops: [0.0, 0.5, 1.0],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Why Choose',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          const Color(0xFFFAAB0C),
                          Colors.yellow.shade600,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'SS Construction?',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 5,
                    width: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFAAB0C), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Building trust through excellence, transparency, and timely delivery',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (0.12 * _pulseController.value);
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFAAB0C), Colors.yellow.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFAAB0C,
                  ).withOpacity(0.3 + (0.3 * _pulseController.value)),
                  blurRadius: 25 + (20 * _pulseController.value),
                  spreadRadius: 3 + (5 * _pulseController.value),
                ),
              ],
            ),
            child: const Icon(Icons.apartment, color: Colors.black, size: 42),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final cardWidth = isWide ? 400.0 : 350.0;

        return Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: List.generate(
            features.length,
            (index) => AnimatedRevealWidget(
              visible: _isVisible,
              delay: 300 + (index * 100),
              child: SizedBox(
                width: cardWidth,
                child: _FeatureCard(feature: features[index], index: index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTASection() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 1200,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFAAB0C).withOpacity(0.15),
                  const Color(0xFFFAAB0C).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(
                  0xFFFAAB0C,
                ).withOpacity(0.3 + (0.2 * _pulseController.value)),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFAAB0C,
                  ).withOpacity(0.1 + (0.1 * _pulseController.value)),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.emoji_events,
                      color: Color(0xFFFAAB0C),
                      size: 36,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Excellence in Every Project',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Join hundreds of satisfied clients who trust SS Construction',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFAAB0C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 8,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Your Project',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final ChoiceFeature feature;
  final int index;

  const _FeatureCard({required this.feature, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          final scale = 1.0 + (0.03 * _hoverController.value);
          final elevation = 5.0 + (15.0 * _hoverController.value);

          return Transform.scale(
            scale: scale,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [
                          widget.feature.gradient[0].withOpacity(0.15),
                          widget.feature.gradient[1].withOpacity(0.05),
                        ]
                      : [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.02),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _isHovered
                      ? widget.feature.accentColor.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? widget.feature.accentColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: elevation,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.feature.gradient,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: widget.feature.accentColor.withOpacity(
                                  0.4,
                                ),
                                blurRadius: _isHovered ? 20 : 10,
                                spreadRadius: _isHovered ? 2 : 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.feature.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.feature.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.feature.accentColor.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            '0${widget.index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: widget.feature.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.feature.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.feature.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        children: [
                          Text(
                            'Learn more',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.feature.accentColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward,
                            color: widget.feature.accentColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Background Painter
class ChoiceBackgroundPainter extends CustomPainter {
  final double animationValue;

  ChoiceBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 8; i++) {
      final offset = (animationValue * 100) % 100;
      final y = (size.height / 8) * i + offset;
      paint.color = const Color(0xFFFAAB0C).withOpacity(0.05);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int i = 0; i < 15; i++) {
      final offset = (animationValue * 80) % 80;
      final x = (size.width / 15) * i + offset;
      paint.color = Colors.white.withOpacity(0.03);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i < 5; i++) {
      final angle = (animationValue * 2 * pi) + (i * pi / 2.5);
      final x = size.width / 2 + cos(angle) * (size.width * 0.3);
      final y = size.height / 2 + sin(angle) * (size.height * 0.25);

      paint.color = const Color(0xFFFAAB0C).withOpacity(0.03);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 80, paint);

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      paint.color = const Color(0xFFFAAB0C).withOpacity(0.08);
      canvas.drawCircle(Offset(x, y), 80, paint);
    }
  }

  @override
  bool shouldRepaint(ChoiceBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
