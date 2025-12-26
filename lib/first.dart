import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ModernHeroSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final Function(int) scrollToSection;
  final AnimationController heroController;

  const ModernHeroSection({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.scrollToSection,
    required this.heroController,
  });

  @override
  State<ModernHeroSection> createState() => _ModernHeroSectionState();
}

class _ModernHeroSectionState extends State<ModernHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;

  // Text animations
  final List<TextAnimation> _textAnimations = [];
  final List<String> _texts = [
    'SS Construction',
    'Building Excellence Since 2000',
    'Transforming Visions into Reality',
    'Leading construction company delivering innovative infrastructure solutions with precision, quality, and excellence.',
  ];

  // Particle system
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize particles
    _initializeParticles();

    // Initialize text animations
    _initializeTextAnimations();

    // Setup main animations
    _setupAnimations();

    // Start animations
    _startTextTyping();
  }

  void _initializeParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: 1.0 + _random.nextDouble() * 3.0,
          speed: 0.1 + _random.nextDouble() * 0.3,
          color: _getRandomColor(),
        ),
      );
    }
  }

  void _initializeTextAnimations() {
    for (int i = 0; i < _texts.length; i++) {
      _textAnimations.add(
        TextAnimation(
          controller: TextEditingController(),
          text: _texts[i],
          delay: i * 200,
          speed: i == 0 ? 40 : (i == 1 ? 50 : (i == 2 ? 60 : 80)),
        ),
      );
    }
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _glowAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: 0.5,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.6),
            weight: 0.25,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.6, end: 1.0),
            weight: 0.25,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
        );

    _controller.forward();
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFBBF24),
      const Color(0xFF60A5FA),
      const Color(0xFF34D399),
      const Color(0xFFA78BFA),
      const Color(0xFFF87171),
      const Color(0xFF38BDF8),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Future<void> _startTextTyping() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final textAnim in _textAnimations) {
      await _typeText(textAnim);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _typeText(TextAnimation textAnim) async {
    for (int i = 0; i <= textAnim.text.length; i++) {
      await Future.delayed(Duration(milliseconds: textAnim.speed));
      if (mounted) {
        textAnim.controller.text = textAnim.text.substring(0, i);
      }
    }
  }

  Widget _buildParticle(Particle particle) {
    return Positioned(
      left: particle.x * MediaQuery.of(context).size.width,
      top: particle.y * MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: widget.heroController,
        builder: (context, child) {
          final offset = (widget.heroController.value + particle.speed) % 1.0;
          return Transform.translate(
            offset: Offset(0, sin(offset * 2 * pi) * 20),
            child: Opacity(
              opacity: 0.3 + sin(offset * 2 * pi).abs() * 0.4,
              child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: particle.color,
                  boxShadow: [
                    BoxShadow(
                      color: particle.color.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = widget.isMobile ? 600.0 : (widget.isTablet ? 650.0 : 750.0);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: widget.heroController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + sin(widget.heroController.value * pi) * 0.02,
                  child: Lottie.asset(
                    'images/landing.json',
                    fit: BoxFit.cover,
                    animate: true,
                    repeat: true,
                    frameRate: FrameRate(60),
                  ),
                );
              },
            ),
          ),

          // Dynamic Gradient Overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: widget.heroController,
              builder: (context, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating Particles
          ..._particles.map(_buildParticle).toList(),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: widget.isMobile ? size.width : 1200,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isMobile
                          ? 24
                          : (widget.isTablet ? 40 : 60),
                      vertical: widget.isMobile ? 40 : 60,
                    ),
                    child: _buildHeroContent(),
                  ),
                ),
              ),
            ),
          ),

          // Scroll Indicator
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _buildAnimatedScrollIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge
                  _buildAnimatedBadge(),
                  SizedBox(height: widget.isMobile ? 30 : 40),

                  // Main Title
                  _buildAnimatedTitle(),
                  SizedBox(height: widget.isMobile ? 20 : 28),

                  // Subtitle
                  _buildAnimatedSubtitle(),
                  SizedBox(height: widget.isMobile ? 24 : 32),

                  // Description
                  _buildAnimatedDescription(),
                  SizedBox(height: widget.isMobile ? 35 : 50),

                  // CTA Buttons
                  _buildAnimatedButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBadge() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_controller.value * 0.1),
          child: Opacity(
            opacity: _controller.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 16 : 24,
                vertical: widget.isMobile ? 8 : 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFFFBBF24,
                    ).withOpacity(0.4 * _glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedIcon(
                    icon: Icons.stars_rounded,
                    color: Colors.white,
                    size: widget.isMobile ? 20 : 24,
                    animation: _controller,
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _textAnimations[1].controller,
                    builder: (context, value, child) {
                      return Text(
                        value.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isMobile
                              ? 11
                              : (widget.isTablet ? 13 : 15),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withOpacity(_controller.value),
                const Color(0xFFFBBF24).withOpacity(_controller.value),
                const Color(0xFFFFFFFF).withOpacity(_controller.value),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textAnimations[0].controller,
            builder: (context, value, child) {
              return Text(
                value.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.isMobile ? 40 : (widget.isTablet ? 60 : 80),
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: const Color(
                        0xFFFBBF24,
                      ).withOpacity(0.6 * _glowAnimation.value),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubtitle() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 - (_controller.value * 20)),
          child: Opacity(
            opacity: _controller.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 20 : 28,
                vertical: widget.isMobile ? 10 : 14,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4 * _controller.value),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(
                    0xFFFBBF24,
                  ).withOpacity(0.3 * _controller.value),
                  width: 1,
                ),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textAnimations[2].controller,
                builder: (context, value, child) {
                  return Text(
                    value.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.isMobile
                          ? 18
                          : (widget.isTablet ? 24 : 28),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFBBF24),
                      letterSpacing: 1.2,
                      height: 1.3,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDescription() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _controller.drive(
            CurveTween(curve: const Interval(0.5, 1.0)),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widget.isMobile
                  ? double.infinity
                  : (widget.isTablet ? 600 : 700),
            ),
            padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 0 : 20),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textAnimations[3].controller,
              builder: (context, value, child) {
                return Text(
                  value.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.isMobile
                        ? 14
                        : (widget.isTablet ? 16 : 18),
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButtons() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 40 - (_controller.value * 40)),
          child: Opacity(
            opacity: _controller.value,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: widget.isMobile ? 12 : 20,
              runSpacing: widget.isMobile ? 12 : 20,
              children: [
                _buildCTAButton(
                  label: 'Explore Projects',
                  icon: Icons.arrow_forward_rounded,
                  isPrimary: true,
                  onTap: () => widget.scrollToSection(3),
                ),
                _buildCTAButton(
                  label: 'Contact Us',
                  icon: Icons.phone_outlined,
                  isPrimary: false,
                  onTap: () => widget.scrollToSection(11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTAButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_glowAnimation.value * 0.05),
            child: Container(
              decoration: BoxDecoration(
                gradient: isPrimary
                    ? LinearGradient(
                        colors: [
                          const Color(0xFFFBBF24),
                          const Color(0xFFF59E0B),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(35),
                border: isPrimary
                    ? null
                    : Border.all(color: const Color(0xFFFBBF24), width: 2),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isPrimary
                                ? const Color(0xFFFBBF24)
                                : Colors.transparent)
                            .withOpacity(0.4 * _glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(35),
                  hoverColor: Colors.white.withOpacity(0.1),
                  splashColor: const Color(0xFFFBBF24).withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isMobile ? 24 : 32,
                      vertical: widget.isMobile ? 14 : 18,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isMobile ? 14 : 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedIcon(
                          icon: icon,
                          color: Colors.white,
                          size: widget.isMobile ? 18 : 22,
                          animation: _controller,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedScrollIndicator() {
    return AnimatedBuilder(
      animation: widget.heroController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 8 * sin(widget.heroController.value * 2 * pi)),
          child: Column(
            children: [
              Text(
                'Scroll to Explore',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: widget.isMobile ? 11 : 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedIcon(
                icon: Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFFFBBF24),
                size: widget.isMobile ? 28 : 36,
                animation: widget.heroController,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final textAnim in _textAnimations) {
      textAnim.controller.dispose();
    }
    super.dispose();
  }
}

// =====================================================
// HELPER CLASSES
// =====================================================

class TextAnimation {
  final TextEditingController controller;
  final String text;
  final int delay;
  final int speed;

  TextAnimation({
    required this.controller,
    required this.text,
    this.delay = 0,
    this.speed = 50,
  });
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class AnimatedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Animation<double> animation;

  const AnimatedIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: animation.value * 0.1,
          child: Transform.scale(
            scale: 0.9 + animation.value * 0.2,
            child: Icon(icon, color: color, size: size),
          ),
        );
      },
    );
  }
}
