// ===== Premium Parallax Projects Section with Complete Data Representation =====
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _parallaxController;
  late AnimationController _particleController;
  late AnimationController _waveController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> layoutProjects = [
    {
      'name': 'Pawangaon',
      'status': 'Completed',
      'area': '45 Acres',
      'plots': '250+',
      'year': '2022',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Kapsi',
      'status': 'In Progress',
      'area': '38 Acres',
      'plots': '180+',
      'year': '2024',
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Bhilgaon',
      'status': 'Completed',
      'area': '52 Acres',
      'plots': '300+',
      'year': '2021',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Ranala',
      'status': 'Completed',
      'area': '41 Acres',
      'plots': '220+',
      'year': '2022',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Lonara',
      'status': 'In Progress',
      'area': '35 Acres',
      'plots': '165+',
      'year': '2024',
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Bokhara',
      'status': 'Completed',
      'area': '48 Acres',
      'plots': '275+',
      'year': '2023',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Mauda',
      'status': 'Planning',
      'area': '60 Acres',
      'plots': '350+',
      'year': '2025',
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'Shankarpur',
      'status': 'Completed',
      'area': '44 Acres',
      'plots': '240+',
      'year': '2023',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Dhanla',
      'status': 'In Progress',
      'area': '39 Acres',
      'plots': '195+',
      'year': '2024',
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Lapka',
      'status': 'Completed',
      'area': '46 Acres',
      'plots': '260+',
      'year': '2022',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Lava',
      'status': 'Planning',
      'area': '55 Acres',
      'plots': '320+',
      'year': '2025',
      'color': Color(0xFFF59E0B),
    },
    {
      'name': 'Mahurzari',
      'status': 'Completed',
      'area': '50 Acres',
      'plots': '290+',
      'year': '2023',
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Godhni',
      'status': 'In Progress',
      'area': '42 Acres',
      'plots': '230+',
      'year': '2024',
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Khairi',
      'status': 'Completed',
      'area': '47 Acres',
      'plots': '265+',
      'year': '2023',
      'color': Color(0xFF10B981),
    },
  ];

  final List<Map<String, dynamic>> roadWorks = [
    {
      'title': 'NMC Road Contract',
      'description': 'CC Road at Prabhag No. 12',
      'details':
          'Construction of high-quality concrete roads with modern infrastructure',
      'icon': Icons.route,
      'location': 'Nagpur Municipal Corporation',
      'type': 'Concrete Road',
      'length': '5.2 KM',
      'budget': '₹12.5 Cr',
      'completion': '85%',
    },
    {
      'title': 'Eye Blog Work',
      'description': 'Prabhag No. 12, Wadi, Dabha',
      'details':
          'Infrastructure development including drainage and road connectivity',
      'icon': Icons.visibility,
      'location': 'Multiple Zones',
      'type': 'Infrastructure',
      'length': '3.8 KM',
      'budget': '₹8.2 Cr',
      'completion': '70%',
    },
  ];

  final List<Map<String, dynamic>> clients = [
    {
      'name': 'Saraswati Nagri',
      'subtitle': 'Premium Developer',
      'description':
          'Long-term partnership in developing premium residential layouts',
      'projects': '5+',
      'rating': 5,
      'revenue': '₹25+ Cr',
      'since': '2020',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat(reverse: true);
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this,
    )..repeat();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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
    _parallaxController.dispose();
    _particleController.dispose();
    _waveController.dispose();
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

        return Stack(
          children: [
            _buildPremiumParallaxBackground(),
            _buildFloatingParticles(),
            _buildWaveEffect(),
            _buildGradientOverlay(),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1400),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : (isTablet ? 40 : 60),
                      vertical: isMobile ? 40 : 60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(isMobile),
                          SizedBox(height: isMobile ? 40 : 60),
                          _buildSubSectionHeader(
                            'NMRDA Sanctioned Layout Development',
                            Icons.location_city,
                            '14 Projects • 650+ Acres • 3500+ Plots',
                            isMobile,
                          ),
                          SizedBox(height: isMobile ? 24 : 32),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: _buildProjectsGrid(
                              isDesktop,
                              isTablet,
                              isMobile,
                            ),
                          ),
                          SizedBox(height: isMobile ? 50 : 70),
                          _buildSubSectionHeader(
                            'Government Road Works',
                            Icons.construction,
                            'PWD, NMC & Zilla Parishad',
                            isMobile,
                          ),
                          SizedBox(height: isMobile ? 24 : 32),
                          _buildRoadWorksSection(isMobile),
                          SizedBox(height: isMobile ? 50 : 70),
                          _buildSubSectionHeader(
                            'Our Valued Clientele',
                            Icons.business,
                            'Trusted Partners',
                            isMobile,
                          ),
                          SizedBox(height: isMobile ? 24 : 32),
                          _buildClientSection(isMobile),
                          SizedBox(height: isMobile ? 24 : 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumParallaxBackground() {
    return AnimatedBuilder(
      animation: _parallaxController,
      builder: (context, child) {
        return Positioned.fill(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 2.0,
                    colors: [
                      Color(0xFF1a1a2e),
                      Color(0xFF0f0f1e),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                top:
                    50 +
                    (math.sin(_parallaxController.value * 2 * math.pi) * 80),
                right:
                    -150 +
                    (math.cos(_parallaxController.value * 2 * math.pi) * 60),
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFFAAB0C).withOpacity(0.25),
                        Color(0xFFFF8C00).withOpacity(0.15),
                        Color(0xFFFF6B35).withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.3, 0.6, 1.0],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom:
                    100 +
                    (math.cos(_parallaxController.value * 3 * math.pi) * 60),
                left:
                    -100 +
                    (math.sin(_parallaxController.value * 3 * math.pi) * 50),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFF6366F1).withOpacity(0.2),
                        Color(0xFF8B5CF6).withOpacity(0.12),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.04,
                  child: CustomPaint(
                    painter: AnimatedGridPainter(
                      offset: _parallaxController.value * 30,
                      phase: _parallaxController.value * 2 * math.pi,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: ParticlesPainter(
              animationValue: _particleController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveEffect() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 200,
            child: CustomPaint(
              painter: WavePainter(animationValue: _waveController.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.4),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFAAB0C).withOpacity(0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: isMobile ? 28 : 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Projects',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFAAB0C),
                          Color(0xFFFF8C00),
                          Colors.transparent,
                        ],
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
          'Excellence in Infrastructure & Development',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: Colors.white60,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubSectionHeader(
    String title,
    IconData icon,
    String subtitle,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAAB0C).withOpacity(0.15),
            Color(0xFFFF8C00).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFAAB0C).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFAAB0C).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFAAB0C).withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: isMobile ? 22 : 26),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsGrid(bool isDesktop, bool isTablet, bool isMobile) {
    int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isMobile ? 1.3 : 1.1,
        crossAxisSpacing: isMobile ? 16 : 20,
        mainAxisSpacing: isMobile ? 16 : 20,
      ),
      itemCount: layoutProjects.length,
      itemBuilder: (context, index) {
        return EnhancedProjectCard(
          project: layoutProjects[index],
          delay: Duration(milliseconds: 200 + (index * 80)),
          isMobile: isMobile,
        );
      },
    );
  }

  Widget _buildRoadWorksSection(bool isMobile) {
    return Column(
      children: List.generate(roadWorks.length, (index) {
        return EnhancedRoadWorkCard(
          roadWork: roadWorks[index],
          delay: Duration(milliseconds: 400 + (index * 200)),
          isMobile: isMobile,
        );
      }),
    );
  }

  Widget _buildClientSection(bool isMobile) {
    return EnhancedClientCard(
      client: clients[0],
      delay: Duration(milliseconds: 600),
      isMobile: isMobile,
    );
  }
}

// ===== Custom Painters =====
class AnimatedGridPainter extends CustomPainter {
  final double offset;
  final double phase;

  AnimatedGridPainter({required this.offset, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    const gridSize = 60.0;

    for (double x = offset % gridSize; x < size.width; x += gridSize) {
      final opacity = (math.sin(phase + x / 100) + 1) / 2;
      paint.color = Colors.white.withOpacity(0.05 * opacity);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = offset % gridSize; y < size.height; y += gridSize) {
      final opacity = (math.cos(phase + y / 100) + 1) / 2;
      paint.color = Colors.white.withOpacity(0.05 * opacity);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(AnimatedGridPainter oldDelegate) =>
      offset != oldDelegate.offset || phase != oldDelegate.phase;
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const particleCount = 50;
    final random = math.Random(42);

    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.2 + random.nextDouble() * 0.3;
      final y = (baseY + animationValue * size.height * speed) % size.height;
      final size1 = 1 + random.nextDouble() * 2;
      final opacity = 0.1 + random.nextDouble() * 0.3;

      final gradient = RadialGradient(
        colors: [Color(0xFFFAAB0C).withOpacity(opacity), Colors.transparent],
      );
      paint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(x, y), radius: size1 * 3),
      );
      canvas.drawCircle(Offset(x, y), size1, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFAAB0C).withOpacity(0.1),
          Color(0xFFFF8C00).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height * 0.3 +
          math.sin(
                (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              30 +
          math.sin(
                (x / size.width * 4 * math.pi) - (animationValue * math.pi),
              ) *
              15;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}

// ===== Enhanced Project Card =====
class EnhancedProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Duration delay;
  final bool isMobile;

  const EnhancedProjectCard({
    super.key,
    required this.project,
    required this.delay,
    required this.isMobile,
  });

  @override
  State<EnhancedProjectCard> createState() => _EnhancedProjectCardState();
}

class _EnhancedProjectCardState extends State<EnhancedProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
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
    final statusColor = widget.project['color'] as Color;
    final status = widget.project['status'] as String;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color.fromARGB(85, 255, 255, 255).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
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
                          Icons.location_city,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17),
                  Text(
                    widget.project['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isMobile ? 20 : 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NMRDA Sanctioned Layout',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  SizedBox(height: 26),

                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                Icons.landscape,
                                'Area',
                                widget.project['area'],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                Icons.grid_on,
                                'Plots',
                                widget.project['plots'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Color(0xFFFAAB0C),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Year: ${widget.project['year']}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Color(0xFFFAAB0C)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }
}

// ===== Enhanced Road Work Card =====
class EnhancedRoadWorkCard extends StatefulWidget {
  final Map<String, dynamic> roadWork;
  final Duration delay;
  final bool isMobile;

  const EnhancedRoadWorkCard({
    super.key,
    required this.roadWork,
    required this.delay,
    required this.isMobile,
  });

  @override
  State<EnhancedRoadWorkCard> createState() => _EnhancedRoadWorkCardState();
}

class _EnhancedRoadWorkCardState extends State<EnhancedRoadWorkCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
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
    final completion =
        double.parse(widget.roadWork['completion'].replaceAll('%', '')) / 100;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.only(bottom: widget.isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.roadWork['icon'],
                        color: Colors.white,
                        size: widget.isMobile ? 24 : 28,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.roadWork['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isMobile ? 18 : 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.roadWork['description'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: widget.isMobile ? 13 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Color(0xFFFAAB0C),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Project Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.roadWork['details'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: widget.isMobile ? 12 : 13,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailChip(
                              Icons.straighten,
                              'Length',
                              widget.roadWork['length'],
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildDetailChip(
                              Icons.currency_rupee,
                              'Budget',
                              widget.roadWork['budget'],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFFFAAB0C),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.roadWork['location'],
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: widget.isMobile ? 11 : 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Completion Progress',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.roadWork['completion'],
                                style: TextStyle(
                                  color: Color(0xFFFAAB0C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: completion,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFAAB0C),
                                          Color(0xFFFF8C00),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
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
  }

  Widget _buildDetailChip(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFAAB0C).withOpacity(0.2),
            Color(0xFFFF8C00).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFFAAB0C).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Color(0xFFFAAB0C)),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.white60, fontSize: 9),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Enhanced Client Card (No Hover Colors) =====
class EnhancedClientCard extends StatefulWidget {
  final Map<String, dynamic> client;
  final Duration delay;
  final bool isMobile;

  const EnhancedClientCard({
    super.key,
    required this.client,
    required this.delay,
    required this.isMobile,
  });

  @override
  State<EnhancedClientCard> createState() => _EnhancedClientCardState();
}

class _EnhancedClientCardState extends State<EnhancedClientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.isMobile ? 20 : 28),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFAAB0C), Color(0xFFFF8C00)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.business_center,
                        color: Colors.white,
                        size: widget.isMobile ? 28 : 34,
                      ),
                    ),
                    SizedBox(width: widget.isMobile ? 16 : 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.client['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isMobile ? 20 : 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFAAB0C).withOpacity(0.3),
                                  Color(0xFFFF8C00).withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xFFFAAB0C).withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Color(0xFFFAAB0C),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  widget.client['subtitle'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.isMobile ? 11 : 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: widget.isMobile ? 16 : 20),
                Container(
                  padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    widget.client['description'],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: widget.isMobile ? 13 : 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: widget.isMobile ? 20 : 24),
                Container(
                  padding: EdgeInsets.all(widget.isMobile ? 14 : 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          Icons.folder_special,
                          'Projects',
                          widget.client['projects'],
                        ),
                      ),
                      _divider(),
                      Expanded(
                        child: _buildStatItem(
                          Icons.star,
                          'Rating',
                          '${widget.client['rating']}.0',
                        ),
                      ),
                      _divider(),
                      Expanded(
                        child: _buildStatItem(
                          Icons.currency_rupee,
                          'Revenue',
                          widget.client['revenue'],
                        ),
                      ),
                      _divider(),
                      Expanded(
                        child: _buildStatItem(
                          Icons.calendar_today,
                          'Since',
                          widget.client['since'],
                        ),
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
  }

  Widget _divider() {
    return Container(
      width: 2,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0xFFFAAB0C).withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Color(0xFFFAAB0C)),
        SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.isMobile ? 13 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: widget.isMobile ? 9 : 10,
          ),
        ),
      ],
    );
  }
}
