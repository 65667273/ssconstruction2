// ===== Responsive About Section with Modern Animations =====
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> bullets = [
    {
      'text': 'NMRDA Sanctioned Layout Development',
      'icon': Icons.apartment,
      'color': Color(0xFF6366F1),
    },
    {
      'text': 'Government Road Contracts (PWD, NMC, Zilla Parishad)',
      'icon': Icons.construction,
      'color': Color(0xFFEC4899),
    },
    {
      'text':
          '7–8 years experience · 500+ workers · 10 engineers · 15 supervisors',
      'icon': Icons.groups,
      'color': Color(0xFF10B981),
    },
  ];

  final List<Map<String, String>> licenses = [
    {'name': 'PWD License Holder', 'badge': 'Certified'},
    {'name': 'NMC License Holder', 'badge': 'Active'},
    {'name': 'Zilla Parishad License Holder', 'badge': 'Verified'},
  ];

  final List<Map<String, String>> owners = [
    {'name': 'Mr. Niklesh Kapse', 'role': 'Co-Owner', 'initial': 'NK'},
    {'name': 'Mr. Rohit Ganvir', 'role': 'Co-Owner', 'initial': 'RG'},
  ];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final isMobile = constraints.maxWidth <= 768;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              constraints: BoxConstraints(maxWidth: 1400),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : (isTablet ? 40 : 60),
                vertical: isMobile ? 40 : 60,
              ),
              child: Column(
                children: [
                  // Section Header with Animated Background
                  _buildSectionHeader(isMobile),
                  SizedBox(height: isMobile ? 40 : 60),

                  // Main Content Layout
                  if (isDesktop)
                    _buildDesktopLayout()
                  else if (isTablet)
                    _buildTabletLayout()
                  else
                    _buildMobileLayout(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(bool isMobile) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            // Animated Background Blur
            Positioned(
              right: -50,
              top: -30,
              child: Transform.translate(
                offset: Offset(
                  math.sin(_floatingController.value * 2 * math.pi) * 20,
                  math.cos(_floatingController.value * 2 * math.pi) * 20,
                ),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFAAB0C).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFAAB0C).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: isMobile ? 24 : 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFAAB0C), Colors.transparent],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Building Tomorrow\'s Infrastructure Today',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.white60,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: _buildContentColumn()),
        SizedBox(width: 40),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              AnimatedStrengthCard(floatingController: _floatingController),
              SizedBox(height: 24),
              _buildQuickStats(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildContentColumn(),
        SizedBox(height: 40),
        AnimatedStrengthCard(floatingController: _floatingController),
        SizedBox(height: 24),
        _buildQuickStats(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContentColumn(),
        SizedBox(height: 32),
        AnimatedStrengthCard(floatingController: _floatingController),
        SizedBox(height: 20),
        _buildQuickStats(),
      ],
    );
  }

  Widget _buildContentColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Introduction with Gradient Background
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            'SS Construction is a trusted name in Nagpur infrastructure and real estate development sector. We deliver durable, legally compliant projects with unmatched quality.',
            style: TextStyle(
              height: 1.8,
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 32),

        // Specialization bullets with modern cards
        ...List.generate(bullets.length, (index) {
          return ModernBulletCard(
            text: bullets[index]['text']!,
            icon: bullets[index]['icon']!,
            color: bullets[index]['color']!,
            delay: Duration(milliseconds: 300 + (index * 150)),
          );
        }),

        SizedBox(height: 40),

        // Licenses Section
        _buildSubSection(
          'Licenses & Credentials',
          Icons.workspace_premium,
          children: List.generate(licenses.length, (index) {
            return ModernLicenseBadge(
              name: licenses[index]['name']!,
              badge: licenses[index]['badge']!,
              delay: Duration(milliseconds: 700 + (index * 100)),
            );
          }),
        ),

        SizedBox(height: 40),

        // Owners Section
        _buildSubSection(
          'Leadership',
          Icons.engineering,
          children: List.generate(owners.length, (index) {
            return ModernOwnerCard(
              name: owners[index]['name']!,
              role: owners[index]['role']!,
              initial: owners[index]['initial']!,
              delay: Duration(milliseconds: 1000 + (index * 150)),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubSection(
    String title,
    IconData icon, {
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFAAB0C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: Color(0xFFFAAB0C)),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFAAB0C).withOpacity(0.1),
            Color(0xFFFF8C00).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFAAB0C).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '🏆 Award Winning Team',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Recognized for excellence in construction and timely project delivery',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.white60, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ===== Modern Bullet Card =====
class ModernBulletCard extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Duration delay;

  const ModernBulletCard({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<ModernBulletCard> createState() => _ModernBulletCardState();
}

class _ModernBulletCardState extends State<ModernBulletCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [
                          widget.color.withOpacity(0.15),
                          widget.color.withOpacity(0.05),
                        ]
                      : [
                          Colors.white.withOpacity(0.06),
                          Colors.white.withOpacity(0.02),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered
                      ? widget.color.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                  width: 2,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.color.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, size: 24, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Modern License Badge =====
class ModernLicenseBadge extends StatefulWidget {
  final String name;
  final String badge;
  final Duration delay;

  const ModernLicenseBadge({
    super.key,
    required this.name,
    required this.badge,
    required this.delay,
  });

  @override
  State<ModernLicenseBadge> createState() => _ModernLicenseBadgeState();
}

class _ModernLicenseBadgeState extends State<ModernLicenseBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAAB0C).withOpacity(0.1), Colors.transparent],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFFAAB0C).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFAAB0C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.verified, size: 20, color: Color(0xFFFAAB0C)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFAAB0C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFFAAB0C).withOpacity(0.5)),
                ),
                child: Text(
                  widget.badge,
                  style: TextStyle(
                    color: Color(0xFFFAAB0C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Modern Owner Card =====
class ModernOwnerCard extends StatefulWidget {
  final String name;
  final String role;
  final String initial;
  final Duration delay;

  const ModernOwnerCard({
    super.key,
    required this.name,
    required this.role,
    required this.initial,
    required this.delay,
  });

  @override
  State<ModernOwnerCard> createState() => _ModernOwnerCardState();
}

class _ModernOwnerCardState extends State<ModernOwnerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isHovered
                    ? [
                        Color(0xFFFAAB0C).withOpacity(0.15),
                        Color(0xFFFF8C00).withOpacity(0.05),
                      ]
                    : [
                        Colors.white.withOpacity(0.06),
                        Colors.white.withOpacity(0.02),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered
                    ? Color(0xFFFAAB0C).withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
                width: 2,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Color(0xFFFAAB0C).withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFAAB0C).withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.initial,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.role,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Animated Strength Card =====
class AnimatedStrengthCard extends StatefulWidget {
  final AnimationController floatingController;

  const AnimatedStrengthCard({super.key, required this.floatingController});

  @override
  State<AnimatedStrengthCard> createState() => _AnimatedStrengthCardState();
}

class _AnimatedStrengthCardState extends State<AnimatedStrengthCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> stats = [
    {
      'label': 'Engineers',
      'value': '10',
      'icon': Icons.engineering,
      'color': Color(0xFF6366F1),
    },
    {
      'label': 'Supervisors',
      'value': '15',
      'icon': Icons.supervisor_account,
      'color': Color(0xFFEC4899),
    },
    {
      'label': 'Skilled Labour',
      'value': '500+',
      'icon': Icons.construction_outlined,
      'color': Color(0xFF10B981),
    },
    {
      'label': 'Modern Machinery',
      'value': 'Owned Fleet',
      'icon': Icons.precision_manufacturing,
      'color': Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFAAB0C).withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated Background
                  Positioned(
                    top: -50,
                    right: -50,
                    child: AnimatedBuilder(
                      animation: widget.floatingController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: widget.floatingController.value * 2 * math.pi,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFFFAAB0C).withOpacity(0.2),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFAAB0C),
                                    Color(0xFFFF8C00),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFFAAB0C).withOpacity(0.4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.groups_3,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Our Strength',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Expert Team & Resources',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 28),

                        // Stats
                        ...List.generate(stats.length, (index) {
                          return AnimatedStatRow(
                            label: stats[index]['label']!,
                            value: stats[index]['value']!,
                            icon: stats[index]['icon']!,
                            color: stats[index]['color']!,
                            delay: Duration(milliseconds: 600 + (index * 150)),
                          );
                        }),

                        SizedBox(height: 28),

                        // CTA Button
                        AnimatedCTAButton(delay: Duration(milliseconds: 1200)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===== Animated Stat Row =====
class AnimatedStatRow extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Duration delay;

  const AnimatedStatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  State<AnimatedStatRow> createState() => _AnimatedStatRowState();
}

class _AnimatedStatRowState extends State<AnimatedStatRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: 14),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isHovered
                    ? [
                        widget.color.withOpacity(0.15),
                        widget.color.withOpacity(0.05),
                      ]
                    : [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.02),
                      ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isHovered
                    ? widget.color.withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.color, widget.color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withOpacity(0.3),
                        widget.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.color.withOpacity(0.5)),
                  ),
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Animated CTA Button =====
class AnimatedCTAButton extends StatefulWidget {
  final Duration delay;

  const AnimatedCTAButton({super.key, required this.delay});

  @override
  State<AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<AnimatedCTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [Color(0xFFFF8C00), Color(0xFFFAAB0C)]
                  : [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFAAB0C).withOpacity(_isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 20 : 15,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(14),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, size: 22, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Book a Site Visit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      transform: Matrix4.translationValues(
                        _isHovered ? 4 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Section Title (Reusable) =====
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
