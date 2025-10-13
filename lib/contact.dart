import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

// Data Model
class ContactMethod {
  final IconData icon;
  final String title;
  final String value;
  final String actionText;
  final List<Color> gradient;
  final Color accentColor;
  final String? link;

  ContactMethod({
    required this.icon,
    required this.title,
    required this.value,
    required this.actionText,
    required this.gradient,
    required this.accentColor,
    this.link,
  });
}

// Main Contact Section
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _rippleController;
  bool _isVisible = false;

  final List<ContactMethod> contactMethods = [
    ContactMethod(
      icon: Icons.location_on,
      title: 'Office Address',
      value: 'Wardha, Maharashtra, India',
      actionText: 'Get Directions',
      gradient: [const Color(0xFFEF4444), const Color(0xFFF87171)],
      accentColor: const Color(0xFFEF4444),
      link: 'https://maps.google.com/?q=Wardha,Maharashtra',
    ),
    ContactMethod(
      icon: Icons.phone,
      title: 'Phone Number',
      value: '+91 86982 30709',
      actionText: 'Call Now',
      gradient: [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
      accentColor: const Color(0xFF3B82F6),
      link: 'tel:+918698230709',
    ),
    ContactMethod(
      icon: Icons.chat,
      title: 'WhatsApp',
      value: '+91 86982 30709',
      actionText: 'Chat on WhatsApp',
      gradient: [const Color(0xFF10B981), const Color(0xFF34D399)],
      accentColor: const Color(0xFF10B981),
      link: 'https://wa.me/918698230709',
    ),
    ContactMethod(
      icon: Icons.email,
      title: 'Email Address',
      value: 'info@ssconstruction.com',
      actionText: 'Send Email',
      gradient: [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
      accentColor: const Color(0xFF8B5CF6),
      link: 'mailto:info@ssconstruction.com',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    _rippleController.dispose();
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
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 70),
                    _buildContactMethods(),
                    const SizedBox(height: 60),
                    _buildMapSection(),
                    const SizedBox(height: 60),
                    _buildCTASection(),
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
            painter: ContactBackgroundPainter(
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
                offset: Offset(0, -8 * _floatController.value),
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
              child: Text(
                'GET IN TOUCH',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAAB0C),
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
                      return LinearGradient(
                        colors: [
                          Colors.white,
                          const Color(0xFFFAAB0C),
                          Colors.white,
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  Container(
                    height: 5,
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAAB0C), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            'We\'re here to help bring your construction dreams to life',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white60,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            if (_rippleController.value < 0.7)
              Container(
                width: 80 + (60 * _rippleController.value),
                height: 80 + (60 * _rippleController.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(
                      0xFFFAAB0C,
                    ).withOpacity(0.5 * (1 - _rippleController.value)),
                    width: 2,
                  ),
                ),
              ),
            // Main icon
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (0.1 * _pulseController.value);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFAAB0C),
                          Colors.yellow.shade700,
                        ],
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
                    child: const Icon(
                      Icons.contact_phone,
                      color: Colors.black,
                      size: 42,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactMethods() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        return Wrap(
          spacing: 30,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: List.generate(
            contactMethods.length,
            (index) => AnimatedRevealWidget(
              visible: _isVisible,
              delay: 300 + (index * 150),
              child: SizedBox(
                height: isWide ? 280 : 250,
                width: isWide ? 320 : 300,
                child: _ContactMethodCard(
                  method: contactMethods[index],
                  index: index,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapSection() {
    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 900,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
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
            color: const Color(0xFFFAAB0C).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFEF4444),
                              const Color(0xFFF87171),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Find Us on Map',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Map Placeholder
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // You can replace this with actual Google Maps widget
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 60,
                                  color: const Color(0xFFFAAB0C),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Wardha, Maharashtra',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _launchURL(
                                      'https://maps.google.com/?q=Wardha,Maharashtra',
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.directions,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'Open in Google Maps',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFAAB0C),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFAAB0C), Colors.yellow.shade700],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFAAB0C,
                  ).withOpacity(0.3 + (0.2 * _pulseController.value)),
                  blurRadius: 30 + (10 * _pulseController.value),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Start Your Project?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Our team is available 24/7 to answer your queries',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _launchURL('tel:+918698230709');
                      },
                      icon: const Icon(Icons.phone, color: Colors.white),
                      label: const Text(
                        'Call Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 8,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _launchURL('https://wa.me/918698230709');
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text(
                        'WhatsApp Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 8,
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

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// Contact Method Card Widget
class _ContactMethodCard extends StatefulWidget {
  final ContactMethod method;
  final int index;

  const _ContactMethodCard({required this.method, required this.index});

  @override
  State<_ContactMethodCard> createState() => _ContactMethodCardState();
}

class _ContactMethodCardState extends State<_ContactMethodCard>
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

  void _launchURL(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
      child: GestureDetector(
        onTap: () => _launchURL(widget.method.link),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            final scale = 1.0 + (0.05 * _hoverController.value);
            final elevation = 5.0 + (20.0 * _hoverController.value);

            return Transform.scale(
              scale: scale,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? [
                            widget.method.gradient[0].withOpacity(0.2),
                            widget.method.gradient[1].withOpacity(0.05),
                          ]
                        : [
                            Colors.white.withOpacity(0.05),
                            Colors.white.withOpacity(0.02),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? widget.method.accentColor.withOpacity(0.6)
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? widget.method.accentColor.withOpacity(0.4)
                          : Colors.black.withOpacity(0.3),
                      blurRadius: elevation,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.method.gradient,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: widget.method.accentColor.withOpacity(0.5),
                              blurRadius: _isHovered ? 25 : 15,
                              spreadRadius: _isHovered ? 3 : 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.method.icon,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.method.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.method.value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? widget.method.accentColor
                              : widget.method.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.method.accentColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.method.actionText,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _isHovered
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: _isHovered ? Colors.white : Colors.white70,
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
      ),
    );
  }
}

// Animated Reveal Widget (same as before)
class AnimatedRevealWidget extends StatelessWidget {
  final Widget child;
  final bool visible;
  final int delay;

  const AnimatedRevealWidget({
    super.key,
    required this.child,
    required this.visible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: visible ? 1.0 : 0.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}

// Background Painter
class ContactBackgroundPainter extends CustomPainter {
  final double animationValue;

  ContactBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Animated grid
    for (int i = 0; i < 10; i++) {
      final offset = (animationValue * 100) % 100;
      final y = (size.height / 10) * i + offset;

      paint.color = const Color(0xFFFAAB0C).withOpacity(0.03);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Floating circles
    for (int i = 0; i < 4; i++) {
      final angle = (animationValue * 2 * math.pi) + (i * math.pi / 2);
      final x = size.width / 2 + math.cos(angle) * (size.width * 0.35);
      final y = size.height / 2 + math.sin(angle) * (size.height * 0.3);

      paint.color = const Color(0xFFFAAB0C).withOpacity(0.05);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 100, paint);
    }
  }

  @override
  bool shouldRepaint(ContactBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
