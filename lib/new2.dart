import 'dart:math';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

// ===================== ROAD ROLLER PAGE - TWO SECTION LAYOUT =====================

class RoadRollerPage extends StatefulWidget {
  const RoadRollerPage({super.key});

  @override
  State<RoadRollerPage> createState() => _RoadRollerPageState();
}

class _RoadRollerPageState extends State<RoadRollerPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Animated Background Grid
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: DynamicGridPainter(
                      offset: _scrollOffset,
                      animation: _rotationController.value,
                    ),
                  );
                },
              ),
            ),

            // Main Scrollable Content
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // SECTION 1: Hero Section with 3D Model
                  _buildSection1Hero(screenHeight, screenWidth, isMobile),
                ],
              ),
            ),

            // Scroll Indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _buildScrollIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== SECTION 1: HERO SECTION =====================
  Widget _buildSection1Hero(
    double screenHeight,
    double screenWidth,
    bool isMobile,
  ) {
    final parallaxOffset = _scrollOffset * 0.5;
    final opacity = (1 - (_scrollOffset / screenHeight)).clamp(0.0, 1.0);
    final scale = (1 - (_scrollOffset / (screenHeight * 2))).clamp(0.85, 1.0);

    return Container(
      height: screenHeight,
      child: Stack(
        children: [
          // Animated Gradient Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(
                          const Color(0xFF0A0A0F),
                          const Color(0xFF1A1A2E),
                          _rotationController.value,
                        )!,
                        const Color(0xFF0A0A0F),
                        Color.lerp(
                          const Color(0xFF0F0F1E),
                          const Color.fromARGB(
                            54,
                            255,
                            107,
                            53,
                          ).withOpacity(0.1),
                          sin(_rotationController.value * pi * 2) * 0.3 + 0.5,
                        )!,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating Particles
          ...List.generate(15, (index) {
            return AnimatedBuilder(
              animation: Listenable.merge([
                _floatingController,
                _rotationController,
              ]),
              builder: (context, child) {
                final angle =
                    (index / 15) * 2 * pi + _rotationController.value * pi;
                final radius = 200 + sin(angle * 2) * 50;
                final x = screenWidth / 2 + cos(angle) * radius;
                final y =
                    screenHeight / 2 +
                    sin(angle) * radius -
                    parallaxOffset * 0.3;

                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: 0.4,
                    child: Container(
                      width: 4 + sin(angle * 3) * 2,
                      height: 4 + sin(angle * 3) * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color.fromARGB(80, 251, 190, 36),
                            Color.fromARGB(78, 255, 107, 53),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              90,
                              251,
                              190,
                              36,
                            ).withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Title Section
          Positioned(
            top: screenHeight * 0.15 - parallaxOffset * 0.2,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: opacity,
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color.fromARGB(103, 251, 190, 36),
                        Color.fromARGB(96, 245, 159, 11),
                        Color.fromARGB(73, 255, 107, 53),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'ROAD ROLLER',
                      style: TextStyle(
                        fontSize: isMobile ? 48 : 80,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: isMobile ? 4 : 10,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'HEAVY-DUTY CONSTRUCTION EQUIPMENT',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 16,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: isMobile ? 2 : 4,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 3D Model
          Center(
            child: Transform.scale(
              scale: scale,
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, sin(_floatingController.value * pi) * 25),
                    child: _build3DModel(
                      src: 'assets/images/road_roller_truck.glb',
                      height: isMobile ? 300 : 450,
                      width: isMobile ? screenWidth * 0.9 : 700,
                    ),
                  );
                },
              ),
            ),
          ),

          // Specs Cards (Bottom)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Opacity(opacity: opacity, child: _buildQuickSpecs(isMobile)),
          ),
        ],
      ),
    );
  }

  // ===================== SECTION 2: ZOOM & DETAILS =====================
  Widget _buildSection2Zoom(
    double screenHeight,
    double screenWidth,
    bool isMobile,
  ) {
    final sectionStart = screenHeight;
    final sectionProgress = ((_scrollOffset - sectionStart) / screenHeight)
        .clamp(0.0, 1.0);
    final zoomScale = 1.0 + (sectionProgress * 2.5);
    final modelOpacity = (1 - sectionProgress * 0.4).clamp(0.3, 1.0);

    return Container(
      height: screenHeight * 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, const Color(0xFF0F0F1E), Colors.black],
        ),
      ),
      child: Stack(
        children: [
          // Zooming 3D Model
          Positioned.fill(
            child: Center(
              child: Transform.scale(
                scale: zoomScale,
                child: Opacity(
                  opacity: modelOpacity,
                  child: _build3DModel(
                    src: 'images/road_roller_truck.glb',
                    height: isMobile ? 350 : 500,
                    width: isMobile ? screenWidth * 0.9 : 800,
                    autoRotate: sectionProgress > 0.3,
                  ),
                ),
              ),
            ),
          ),

          // Animated Scan Lines
          if (sectionProgress > 0.2)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ScanLinePainter(
                      progress: _pulseController.value,
                      opacity: sectionProgress,
                    ),
                  );
                },
              ),
            ),

          // Detail Callouts - Left
          if (sectionProgress > 0.3)
            Positioned(
              left: isMobile ? 20 : 50,
              top: screenHeight * 0.25,
              child: _buildCallout(
                icon: Icons.speed,
                title: 'Max Speed',
                value: '12 km/h',
                description: 'Optimal compaction velocity',
                progress: sectionProgress - 0.3,
                alignment: CrossAxisAlignment.start,
              ),
            ),

          // Detail Callouts - Right
          if (sectionProgress > 0.5)
            Positioned(
              right: isMobile ? 20 : 50,
              top: screenHeight * 0.4,
              child: _buildCallout(
                icon: Icons.engineering,
                title: 'Drum Width',
                value: '2130 mm',
                description: 'Wide coverage area',
                progress: sectionProgress - 0.5,
                alignment: CrossAxisAlignment.end,
              ),
            ),

          // Detail Callouts - Left Bottom
          if (sectionProgress > 0.65)
            Positioned(
              left: isMobile ? 20 : 50,
              top: screenHeight * 0.65,
              child: _buildCallout(
                icon: Icons.layers,
                title: 'Compaction Force',
                value: '320 kN',
                description: 'Heavy-duty performance',
                progress: sectionProgress - 0.65,
                alignment: CrossAxisAlignment.start,
              ),
            ),

          // Detail Callouts - Right Bottom
          if (sectionProgress > 0.8)
            Positioned(
              right: isMobile ? 20 : 50,
              top: screenHeight * 0.85,
              child: _buildCallout(
                icon: Icons.settings_input_component,
                title: 'Engine Power',
                value: '129 HP',
                description: 'Reliable diesel engine',
                progress: sectionProgress - 0.8,
                alignment: CrossAxisAlignment.end,
              ),
            ),

          // Technical Specs Panel (Bottom)
          if (sectionProgress > 0.7)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: ((sectionProgress - 0.7) * 3).clamp(0.0, 1.0),
                child: _buildTechnicalPanel(isMobile),
              ),
            ),
        ],
      ),
    );
  }

  // ===================== HELPER WIDGETS =====================

  Widget _build3DModel({
    required String src,
    required double height,
    required double width,
    bool autoRotate = true,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(103, 251, 190, 36).withOpacity(0.3),
            blurRadius: 60,
            spreadRadius: 20,
          ),
          BoxShadow(
            color: const Color.fromARGB(78, 255, 107, 53).withOpacity(0.2),
            blurRadius: 80,
            spreadRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ModelViewer(
          src: src,
          alt: "Road Roller 3D Model",
          ar: true,
          autoRotate: autoRotate,
          cameraControls: true,
          disableZoom: false,
          backgroundColor: Colors.transparent,
          cameraOrbit: "45deg 75deg auto",
          fieldOfView: "30deg",
          loading: Loading.eager,
          interactionPrompt: InteractionPrompt.none,
        ),
      ),
    );
  }

  Widget _buildQuickSpecs(bool isMobile) {
    final specs = [
      {'label': 'WEIGHT', 'value': '12 tons'},
      {'label': 'WIDTH', 'value': '2.13m'},
      {'label': 'POWER', 'value': '129 HP'},
      {'label': 'TYPE', 'value': 'Vibratory'},
    ];

    return Center(
      child: Wrap(
        spacing: isMobile ? 10 : 20,
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: specs.map((spec) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(83, 251, 190, 36).withOpacity(0.15),
                      const Color.fromARGB(134, 255, 107, 53).withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(
                      132,
                      251,
                      190,
                      36,
                    ).withOpacity(0.3 + (_pulseController.value * 0.2)),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        101,
                        251,
                        190,
                        36,
                      ).withOpacity(0.1 + (_pulseController.value * 0.1)),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      spec['label']!,
                      style: TextStyle(
                        color: const Color(0xFFFBBF24),
                        fontSize: isMobile ? 10 : 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spec['value']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCallout({
    required IconData icon,
    required String title,
    required String value,
    required String description,
    required double progress,
    required CrossAxisAlignment alignment,
  }) {
    return Opacity(
      opacity: (progress * 3).clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 30 * (1 - (progress * 3).clamp(0.0, 1.0))),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(111, 251, 190, 36).withOpacity(0.15),
                    const Color.fromARGB(153, 255, 107, 53).withOpacity(0.08),
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(
                    0xFFFBBF24,
                  ).withOpacity(0.4 + (_pulseController.value * 0.2)),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 280),
              child: Column(
                crossAxisAlignment: alignment,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFBBF24).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFFFBBF24),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    textAlign: alignment == CrossAxisAlignment.start
                        ? TextAlign.left
                        : TextAlign.right,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTechnicalPanel(bool isMobile) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50),
            padding: EdgeInsets.all(isMobile ? 20 : 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFBBF24).withOpacity(0.2),
                  const Color(0xFFFF6B35).withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(
                  0xFFFBBF24,
                ).withOpacity(0.4 + (_pulseController.value * 0.2)),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBBF24).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  ).createShader(bounds),
                  child: Text(
                    'TECHNICAL SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Engineered for maximum compaction efficiency\nwith advanced vibratory technology',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isMobile ? 12 : 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFBBF24).withOpacity(0.15),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_back, color: Color(0xFFFBBF24), size: 20),
                SizedBox(width: 8),
                Text(
                  'BACK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Opacity(
          opacity: (1 - (_scrollOffset / 400)).clamp(0.0, 0.6),
          child: Transform.translate(
            offset: Offset(0, sin(_floatingController.value * pi) * 10),
            child: Column(
              children: [
                Text(
                  'SCROLL TO EXPLORE',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFBBF24).withOpacity(0.7),
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===================== CUSTOM PAINTERS =====================

class DynamicGridPainter extends CustomPainter {
  final double offset;
  final double animation;

  DynamicGridPainter({required this.offset, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 60.0;
    final animatedOffset = (offset * 0.2 + animation * 50) % spacing;

    // Horizontal lines
    for (double i = -animatedOffset; i < size.height + spacing; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Vertical lines
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Accent lines
    final accentPaint = Paint()
      ..color = const Color(0xFFFF6B35).withOpacity(0.05)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height / 2 + sin(animation * 2 * pi) * 100),
      Offset(size.width, size.height / 2 + sin(animation * 2 * pi) * 100),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(DynamicGridPainter oldDelegate) =>
      offset != oldDelegate.offset || animation != oldDelegate.animation;
}

class ScanLinePainter extends CustomPainter {
  final double progress;
  final double opacity;

  ScanLinePainter({required this.progress, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.3 * opacity)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final y = size.height * progress;

    // Main scan line
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

    // Glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.1 * opacity)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawLine(Offset(0, y), Offset(size.width, y), glowPaint);
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) =>
      progress != oldDelegate.progress || opacity != oldDelegate.opacity;
}
