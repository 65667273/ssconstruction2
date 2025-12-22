import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:ss/contact.dart';

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
  late ConfettiController _confettiController;

  bool _show3DModel = false;

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

  final List<Map<String, dynamic>> stats = [
    {'value': '10+', 'label': 'Engineers', 'icon': Icons.engineering},
    {'value': '500+', 'label': 'Workers', 'icon': Icons.people_alt},
    {'value': '50+', 'label': 'Projects', 'icon': Icons.assignment_turned_in},
    {'value': '100%', 'label': 'Satisfaction', 'icon': Icons.thumb_up},
  ];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    // Delayed initialization for better performance
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _mainController.forward();
        _confettiController.play();
      }
    });

    // Lazy load 3D model
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _show3DModel = true);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final isTablet =
            constraints.maxWidth > 600 && constraints.maxWidth <= 1024;
        final isMobile = constraints.maxWidth <= 600;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(maxWidth: 1400),
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Confetti effect - only show briefly
                    if (!isMobile)
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirection: math.pi / 2,
                            maxBlastForce: 15,
                            minBlastForce: 10,
                            emissionFrequency: 0.1,
                            numberOfParticles: 10,
                            gravity: 0.15,
                          ),
                        ),
                      ),

                    // Section Header
                    _buildSectionHeader(isMobile, isTablet),
                    SizedBox(height: isMobile ? 32 : 48),

                    // Stats Cards
                    _buildStatsSection(isMobile, isDesktop, isTablet),
                    SizedBox(height: isMobile ? 32 : 48),

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
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(bool isMobile, bool isTablet) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_floatingController.value * 2 * math.pi) * 3,
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100),
          Text(
            'About SS Construction',
            style: TextStyle(
              fontSize: isMobile ? 28 : (isTablet ? 36 : 48),
              fontWeight: FontWeight.w900,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    Color(0xFFFAAB0C),
                    Color(0xFFFF8C00),
                    Color(0xFFFFA726),
                  ],
                ).createShader(Rect.fromLTWH(0, 0, 400, 70)),
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: isMobile ? 120 : 180,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Building Tomorrow\'s Infrastructure Today with Excellence and Innovation',
            style: TextStyle(
              fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
              color: Colors.white.withOpacity(0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile, bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: isMobile ? 12 : 16,
          runSpacing: isMobile ? 12 : 16,
          children: stats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            return SizedBox(
              width: isMobile
                  ? (constraints.maxWidth - 12) / 2
                  : isTablet
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 48) / 4,
              child: AnimatedStatsCard(
                value: stat['value']!,
                label: stat['label']!,
                icon: stat['icon']!,
                index: index,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _build3DModel(),
              SizedBox(height: 32),
              _buildOwnerCards(false),
            ],
          ),
        ),
        SizedBox(width: 32),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMissionVision(false),
              SizedBox(height: 32),
              _buildSpecialization(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _build3DModel(),
        SizedBox(height: 32),
        _buildOwnerCards(false),
        SizedBox(height: 32),
        _buildMissionVision(false),
        SizedBox(height: 32),
        _buildSpecialization(),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _build3DModel(),
        SizedBox(height: 24),
        _buildOwnerCards(true),
        SizedBox(height: 24),
        _buildMissionVision(true),
        SizedBox(height: 24),
        _buildSpecialization(),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _build3DModel() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E2E), Color(0xFF2D2D44)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFAAB0C).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (_show3DModel)
              ModelViewer(
                src: 'assets/images/abhi.glb',
                alt: "3D Construction Model",
                ar: false,
                autoRotate: true,
                cameraControls: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
                cameraOrbit: "45deg 75deg 3m",
                fieldOfView: "35deg",
                loading: Loading.lazy,
              ),
            if (!_show3DModel)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFAAB0C)),
                    SizedBox(height: 16),
                    Text(
                      'Loading 3D Model...',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (_show3DModel)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.threed_rotation,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Interactive 3D',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerCards(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leadership Team',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        isMobile
            ? Column(
                children: [
                  _buildOwnerCard(
                    name: 'Mr. Niklesh Kapse',
                    role: 'Co-Owner & Technical Director',
                    experience: '8 Years Experience',
                    color: Color(0xFF6366F1),
                    isMobile: true,
                  ),
                  SizedBox(height: 16),
                  _buildOwnerCard(
                    name: 'Mr. Rohit Ganvir',
                    role: 'Co-Owner & Operations Head',
                    experience: '7 Years Experience',
                    color: Color(0xFF10B981),
                    isMobile: true,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildOwnerCard(
                      name: 'Mr. Niklesh Kapse',
                      role: 'Co-Owner & Technical Director',
                      experience: '8 Years Experience',
                      color: Color(0xFF6366F1),
                      isMobile: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildOwnerCard(
                      name: 'Mr. Rohit Ganvir',
                      role: 'Co-Owner & Operations Head',
                      experience: '7 Years Experience',
                      color: Color(0xFF10B981),
                      isMobile: false,
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildOwnerCard({
    required String name,
    required String role,
    required String experience,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 60 : 70,
            height: isMobile ? 60 : 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
            ),
            child: Icon(
              Icons.person,
              size: isMobile ? 30 : 35,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: isMobile ? 15 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            role,
            style: TextStyle(
              fontSize: isMobile ? 12 : 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            experience,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Mission & Vision',
          style: TextStyle(
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        isMobile
            ? Column(
                children: [
                  _buildMissionCard(
                    icon: Icons.flag,
                    title: 'Mission',
                    description:
                        'To deliver superior construction services that exceed client expectations through innovation, quality, and integrity.',
                    color: Color(0xFF6366F1),
                    isMobile: true,
                  ),
                  SizedBox(height: 16),
                  _buildMissionCard(
                    icon: Icons.remove_red_eye,
                    title: 'Vision',
                    description:
                        'To be the most trusted construction partner in Central India, setting benchmarks in quality and sustainability.',
                    color: Color(0xFF10B981),
                    isMobile: true,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildMissionCard(
                      icon: Icons.flag,
                      title: 'Mission',
                      description:
                          'To deliver superior construction services that exceed client expectations through innovation, quality, and integrity.',
                      color: Color(0xFF6366F1),
                      isMobile: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildMissionCard(
                      icon: Icons.remove_red_eye,
                      title: 'Vision',
                      description:
                          'To be the most trusted construction partner in Central India, setting benchmarks in quality and sustainability.',
                      color: Color(0xFF10B981),
                      isMobile: false,
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildMissionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Specialization',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        ...bullets
            .map(
              (bullet) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: AnimatedSpecializationCard(
                  text: bullet['text']!,
                  icon: bullet['icon']!,
                  color: bullet['color']!,
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 24,
          vertical: isMobile ? 12 : 14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: isMobile ? 16 : 18),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 13 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedStatsCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData icon;
  final int index;

  const AnimatedStatsCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.index,
  });

  @override
  State<AnimatedStatsCard> createState() => _AnimatedStatsCardState();
}

class _AnimatedStatsCardState extends State<AnimatedStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late int _displayValue;

  @override
  void initState() {
    super.initState();
    _displayValue = 0;

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    Future.delayed(Duration(milliseconds: 200 + widget.index * 150), () {
      if (mounted) _controller.forward();
    });

    _controller.addListener(() {
      if (mounted) {
        final valueStr = widget.value.replaceAll(RegExp(r'[^0-9]'), '');
        if (valueStr.isNotEmpty) {
          final targetValue = int.parse(valueStr);
          setState(() {
            _displayValue = (_controller.value * targetValue).toInt();
          });
        }
      }
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: Color(0xFFFAAB0C), size: 20),
            ),
            SizedBox(height: 12),
            Text(
              widget.value.contains('+') || widget.value.contains('%')
                  ? widget.value.contains('+')
                        ? '$_displayValue+'
                        : '$_displayValue%'
                  : widget.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                  ).createShader(Rect.fromLTWH(0, 0, 100, 50)),
              ),
            ),
            SizedBox(height: 6),
            Text(
              widget.label,
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSpecializationCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const AnimatedSpecializationCard({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
