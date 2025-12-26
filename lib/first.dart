import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _heroController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigating to section $index')));
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildLottieHeroSection(_isMobile, _isTablet),
            // Add more sections here
          ],
        ),
      ),
    );
  }

  Widget _buildLottieHeroSection(bool isMobile, bool isTablet) {
    final height = isMobile ? 600.0 : (isTablet ? 650.0 : 750.0);

    return RepaintBoundary(
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/images/landing.json',
                fit: BoxFit.cover,
                animate: true,
                repeat: true,
                frameRate: FrameRate(60),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : (isTablet ? 40 : 60),
                        vertical: isMobile ? 40 : 60,
                      ),
                      child: _buildAnimatedHeroContent(isMobile, isTablet),
                    ),
                  ),
                ),
              ),
            ),
            if (!isMobile) ..._buildParticles(height, 8),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _buildScrollIndicator(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles(double height, int count) {
    return List.generate(
      count,
      (index) => RepaintBoundary(
        child: AnimatedBuilder(
          animation: _heroController,
          builder: (context, child) {
            final offset = (_heroController.value + index * 0.2) % 1.0;
            final xPos = 0.1 + (index % 5) * 0.18;
            final yPos = offset;
            final size = 1.5 + (index % 2) * 1.0;

            return Positioned(
              left: MediaQuery.of(context).size.width * xPos,
              top: height * yPos,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFBBF24).withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBBF24).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedHeroContent(bool isMobile, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 8 : 12,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFBBF24).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 20),
              SizedBox(width: isMobile ? 8 : 12),
              Text(
                'Building Excellence Since 2000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 11 : (isTablet ? 13 : 15),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 30 : 40),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFBBF24), Color(0xFFFFFFFF)],
            ).createShader(bounds);
          },
          child: Text(
            'SS Construction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 40 : (isTablet ? 60 : 80),
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Colors.white,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: const Color(0xFFFBBF24).withOpacity(0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: isMobile ? 20 : 28),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 28,
            vertical: isMobile ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFFBBF24).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Transforming Visions into Reality',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : (isTablet ? 24 : 28),
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFBBF24),
              letterSpacing: 1.2,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 24 : 32),
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : (isTablet ? 600 : 700),
          ),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
          child: Text(
            'Leading construction company delivering innovative infrastructure solutions with precision, quality, and excellence.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 35 : 50),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: isMobile ? 12 : 20,
          runSpacing: isMobile ? 12 : 20,
          children: [
            _buildCTAButton(
              label: 'Explore Projects',
              icon: Icons.arrow_forward_rounded,
              isPrimary: true,
              isMobile: isMobile,
              onTap: () => _scrollToSection(3),
            ),
            _buildCTAButton(
              label: 'Contact Us',
              icon: Icons.phone_outlined,
              isPrimary: false,
              isMobile: isMobile,
              onTap: () => _scrollToSection(11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCTAButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required bool isMobile,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                )
              : null,
          borderRadius: BorderRadius.circular(35),
          border: isPrimary
              ? null
              : Border.all(color: const Color(0xFFFBBF24), width: 2),
          boxShadow: [
            BoxShadow(
              color: (isPrimary ? const Color(0xFFFBBF24) : Colors.transparent)
                  .withOpacity(0.4),
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
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 14 : 18,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 14 : 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(icon, color: Colors.white, size: isMobile ? 18 : 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator(bool isMobile) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _heroController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 8 * sin(_heroController.value * 2 * pi)),
            child: Column(
              children: [
                Text(
                  'Scroll to Explore',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: isMobile ? 11 : 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFBBF24),
                  size: isMobile ? 28 : 36,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
