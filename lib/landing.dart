import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ss/MachinerySection.dart';
import 'package:ss/about.dart';
import 'package:ss/contact.dart';
import 'package:ss/main.dart';
import 'package:ss/new.dart';
import 'package:ss/new2.dart';
import 'package:ss/servies.dart';
import 'package:ss/sho.dart';

class ModernHeroSection extends StatefulWidget {
  final bool isMobile;
  final bool isTablet;
  final Function(int) scrollToSection;

  const ModernHeroSection({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.scrollToSection,
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
  late Animation<double> _blurAnimation;
  late Animation<double> _glowAnimation;

  List<String> _animatedTexts = [];
  List<Animation<double>> _textAnimations = [];
  List<TextEditingController> _textControllers = [];

  @override
  void initState() {
    super.initState();

    // Initialize text controllers
    _animatedTexts = [
      'SS Construction',
      'Transforming Visions into Reality',
      'Building Excellence Since 2000',
      'Leading construction company delivering innovative infrastructure solutions with precision, quality, and excellence.',
    ];

    for (int i = 0; i < _animatedTexts.length; i++) {
      _textControllers.add(TextEditingController());
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _blurAnimation = Tween<double>(
      begin: 20.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc));

    _glowAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.3),
            weight: 1,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.3, end: 1.0),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
          ),
        );

    // Create staggered text animations
    for (int i = 0; i < _animatedTexts.length; i++) {
      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.3 + (i * 0.15),
            0.7 + (i * 0.15),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
      _textAnimations.add(animation);
    }

    _controller.forward();

    // Start text typing animation
    _startTextTyping();
  }

  void _startTextTyping() async {
    await Future.delayed(const Duration(milliseconds: 800));

    for (int i = 0; i < _animatedTexts.length; i++) {
      final text = _animatedTexts[i];
      await _typeText(_textControllers[i], text, i == 0 ? 30 : 40);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _typeText(
    TextEditingController controller,
    String text,
    int speed,
  ) async {
    for (int i = 0; i <= text.length; i++) {
      await Future.delayed(Duration(milliseconds: speed));
      if (mounted) {
        controller.text = text.substring(0, i);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = widget.isMobile ? 600.0 : (widget.isTablet ? 650.0 : 750.0);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Animated Lottie Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_blurAnimation.value * 0.01),
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

          // Gradient Overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8 * _fadeAnimation.value),
                        Colors.black.withOpacity(0.4 * _fadeAnimation.value),
                        Colors.black.withOpacity(0.9 * _fadeAnimation.value),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Animated Particles
          ..._buildAnimatedParticles(height),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
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
            child: Opacity(opacity: _fadeAnimation.value, child: child),
          ),
        );
      },
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
    );
  }

  Widget _buildAnimatedBadge() {
    return AnimatedBuilder(
      animation: _textAnimations[2],
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_textAnimations[2].value * 0.1),
          child: Opacity(
            opacity: _textAnimations[2].value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 16 : 24,
                vertical: widget.isMobile ? 8 : 12,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
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
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 12),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _textControllers[2],
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
      animation: _textAnimations[0],
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                const Color(0xFFFFFFFF).withOpacity(_textAnimations[0].value),
                const Color(0xFFFBBF24).withOpacity(_textAnimations[0].value),
                const Color(0xFFFFFFFF).withOpacity(_textAnimations[0].value),
              ],
            ).createShader(bounds);
          },
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textControllers[0],
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
      animation: _textAnimations[1],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 - (_textAnimations[1].value * 10)),
          child: Opacity(
            opacity: _textAnimations[1].value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 20 : 28,
                vertical: widget.isMobile ? 10 : 14,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4 * _textAnimations[1].value),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(
                    0xFFFBBF24,
                  ).withOpacity(0.3 * _textAnimations[1].value),
                  width: 1,
                ),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textControllers[1],
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
      animation: _textAnimations[3],
      builder: (context, child) {
        return FadeTransition(
          opacity: _textAnimations[3],
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widget.isMobile
                  ? double.infinity
                  : (widget.isTablet ? 600 : 700),
            ),
            padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 0 : 20),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textControllers[3],
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
          offset: Offset(0, 20 - (_controller.value * 20)),
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
          return Container(
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(35),
              border: isPrimary
                  ? null
                  : Border.all(color: const Color(0xFFFBBF24), width: 2),
              boxShadow: [
                BoxShadow(
                  color:
                      (isPrimary ? const Color(0xFFFBBF24) : Colors.transparent)
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
                      Icon(
                        icon,
                        color: Colors.white,
                        size: widget.isMobile ? 18 : 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAnimatedParticles(double height) {
    return List.generate(8, (index) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.1 + (index * 0.05),
                0.6 + (index * 0.05),
                curve: Curves.easeOutCubic,
              ),
            ),
          );

          final offset = (_controller.value + index * 0.2) % 1.0;
          final xPos = 0.1 + (index % 5) * 0.18;
          final yPos = offset;
          final size = 1.5 + (index % 2) * 1.0;

          return Positioned(
            left: MediaQuery.of(context).size.width * xPos,
            top: height * yPos,
            child: Opacity(
              opacity: animation.value,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(
                    0xFFFBBF24,
                  ).withOpacity(0.25 * animation.value),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFFFBBF24,
                      ).withOpacity(0.3 * animation.value),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildAnimatedScrollIndicator() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 8 * sin(_controller.value * 2 * pi)),
          child: Opacity(
            opacity: _controller.value,
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
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFBBF24),
                  size: widget.isMobile ? 28 : 36,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Update your _LandingScreenState class to use the new hero section:

// In your build method, replace:
// SectionWrapper(
//   key: _heroKey,
//   child: _buildLottieHeroSection(isMobile, isTablet),
// ),

// With:
// SectionWrapper(
//   key: _heroKey,
//   child: ModernHeroSection(
//     isMobile: isMobile,
//     isTablet: isTablet,
//     scrollToSection: _scrollToSection,
//   ),
// ),
