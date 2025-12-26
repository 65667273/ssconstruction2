import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ss/MachinerySection.dart';
import 'package:ss/about.dart';
import 'package:ss/contact.dart';
import 'package:ss/main.dart';
import 'package:ss/new.dart';
import 'package:ss/new2.dart';
import 'package:ss/servies.dart';
import 'package:ss/sho.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _heroController;

  // Section Keys for Navigation
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _roadRollerKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _howWeWorkKey = GlobalKey();
  final GlobalKey _machineryKey = GlobalKey();
  final GlobalKey _qualityKey = GlobalKey();
  final GlobalKey _teamKey = GlobalKey();
  final GlobalKey _mediaKey = GlobalKey();
  final GlobalKey _whyChooseKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  final Map<int, bool> _sectionVisibility = {};
  bool _showNavBar = false;
  bool _showPopup = false;
  int _activeSection = 0;

  final List<NavigationItem> _navItems = const [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.info_outline, label: 'About'),
    NavigationItem(icon: Icons.construction_outlined, label: 'Road Roller'),
    NavigationItem(icon: Icons.work_outline, label: 'Projects'),
    NavigationItem(icon: Icons.construction, label: 'How We Work'),
    NavigationItem(icon: Icons.precision_manufacturing, label: 'Machinery'),
    NavigationItem(icon: Icons.verified, label: 'Quality'),
    NavigationItem(icon: Icons.groups, label: 'Team'),
    NavigationItem(icon: Icons.photo_library, label: 'Media'),
    NavigationItem(icon: Icons.thumb_up_outlined, label: 'Why Choose Us'),
    NavigationItem(icon: Icons.star_outline, label: 'Features'),
    NavigationItem(icon: Icons.contact_mail, label: 'Contact'),
  ];

  late final List<GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();

    _sectionKeys = [
      _heroKey,
      _aboutKey,
      _roadRollerKey,
      _projectsKey,
      _howWeWorkKey,
      _machineryKey,
      _qualityKey,
      _teamKey,
      _mediaKey,
      _whyChooseKey,
      _featuresKey,
      _contactKey,
    ];

    for (int i = 0; i < 12; i++) {
      _sectionVisibility[i] = i == 0;
    }

    _scrollController = ScrollController()..addListener(_onScroll);
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _preloadAssets();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showNavBar = true);
    });

    // Show popup after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showPopup = true);
    });
  }

  void _preloadAssets() {
    Lottie.asset('assets/images/landing.json');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _heroController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    bool needsUpdate = false;

    // Dynamically detect active section based on scroll position
    int newActiveSection = 0;
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: null);

        // Check if section is in viewport (with some offset for navbar)
        if (position.dy <= 150) {
          newActiveSection = i;
          break;
        }
      }
    }

    if (_activeSection != newActiveSection) {
      _activeSection = newActiveSection;
      needsUpdate = true;
    }

    // Handle section visibility for lazy loading
    for (int i = 1; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(this.context).size.height;

        // Make section visible if it's near viewport
        final shouldBeVisible = position.dy < screenHeight + 300;
        if (_sectionVisibility[i] != shouldBeVisible) {
          _sectionVisibility[i] = shouldBeVisible;
          needsUpdate = true;
        }
      }
    }

    if (needsUpdate) setState(() {});
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    final context = key.currentContext;

    if (context != null) {
      // Use Scrollable.ensureVisible for smooth, reliable scrolling
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.0, // Align to top
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );

      setState(() => _activeSection = index);
    } else {
      // Fallback: try again after a short delay if context not available
      Future.delayed(const Duration(milliseconds: 100), () {
        final retryContext = key.currentContext;
        if (retryContext != null && mounted) {
          Scrollable.ensureVisible(
            retryContext,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            alignment: 0.0,
          );
          setState(() => _activeSection = index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const ColoredBox(color: Colors.black),

          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SectionWrapper(
                  key: _heroKey,
                  child: _buildLottieHeroSection(isMobile, isTablet),
                ),
                _buildLazySection(_aboutKey, 1, const AboutSection(), 600),
                _buildLazySection(
                  _roadRollerKey,
                  2,
                  const RoadRollerPage(),
                  700,
                ),
                _buildLazySection(
                  _projectsKey,
                  3,
                  const ProjectsSection(),
                  800,
                ),
                _buildLazySection(
                  _howWeWorkKey,
                  4,
                  const HowWeWorkSection(),
                  900,
                  const Color(0xFF060606),
                ),
                _buildLazySection(
                  _machineryKey,
                  5,
                  const MachinerySection(),
                  700,
                ),
                _buildLazySection(
                  _qualityKey,
                  6,
                  const QualityStandardsSection(),
                  600,
                ),
                _buildLazySection(
                  _teamKey,
                  7,
                  const TeamStrengthSection(),
                  600,
                ),
                _buildLazySection(
                  _mediaKey,
                  8,
                  const MediaGallerySection(),
                  800,
                ),
                _buildLazySection(
                  _whyChooseKey,
                  9,
                  const WhyChooseSSSection(),
                  700,
                ),
                _buildLazySection(
                  _featuresKey,
                  10,
                  const InteractiveFeaturesSection(),
                  600,
                ),
                _buildLazySection(
                  _contactKey,
                  11,
                  const ContactSection(),
                  700,
                  const Color(0xFF060606),
                ),
                _buildFooter(),
              ],
            ),
          ),

          // Floating Navigation Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            top: _showNavBar ? 20 : -100,
            left: 20,
            right: 20,
            child: FloatingNavigationBar(
              items: _navItems,
              activeIndex: _activeSection,
              onTap: _scrollToSection,
            ),
          ),

          // Scroll Progress Indicator
          if (!isMobile)
            Positioned(
              right: 20,
              top: 120,
              bottom: 100,
              child: ScrollProgressIndicator(
                controller: _scrollController,
                activeSection: _activeSection,
                totalSections: 12,
                onTap: _scrollToSection,
              ),
            ),

          // Sticky WhatsApp Button
          Positioned(
            right: 20,
            bottom: 20,
            child: WhatsAppFloatingButton(phoneNumber: '+919823388866'),
          ),

          // Modern Popup Form
          if (_showPopup)
            ModernPopupForm(
              onClose: () => setState(() => _showPopup = false),
              phoneNumber: '+919823388866',
            ),
        ],
      ),
    );
  }

  Widget _buildLazySection(
    GlobalKey key,
    int index,
    Widget child,
    double height, [
    Color? color,
  ]) {
    return SectionWrapper(
      key: key,
      color: color,
      child: _sectionVisibility[index] == true
          ? RepaintBoundary(child: AnimatedReveal(visible: true, child: child))
          : SectionPlaceholder(height: height),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F0F0F), Color(0xFF000000)],
        ),
      ),
      child: Column(
        children: [
          Text(
            '© ${DateTime.now().year} SS Construction — All rights reserved',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Building Tomorrow, Today',
            style: TextStyle(
              color: Color(0xFFFBBF24),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

// =====================================================
// WHATSAPP FLOATING BUTTON
// =====================================================
class WhatsAppFloatingButton extends StatefulWidget {
  final String phoneNumber;

  const WhatsAppFloatingButton({super.key, required this.phoneNumber});

  @override
  State<WhatsAppFloatingButton> createState() => _WhatsAppFloatingButtonState();
}

class _WhatsAppFloatingButtonState extends State<WhatsAppFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/${widget.phoneNumber.replaceAll('+', '')}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF25D366).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: const Color(0xFF25D366),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _launchWhatsApp,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.chat, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// MODERN POPUP FORM
// =====================================================
class ModernPopupForm extends StatefulWidget {
  final VoidCallback onClose;
  final String phoneNumber;

  const ModernPopupForm({
    super.key,
    required this.onClose,
    required this.phoneNumber,
  });

  @override
  State<ModernPopupForm> createState() => _ModernPopupFormState();
}

class _ModernPopupFormState extends State<ModernPopupForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedService = 'Service 1';

  final List<String> _services = ['Service 1', 'Service 2', 'Service 3'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final message =
          '''Hello SS Construction!

Name: ${_nameController.text}
Mobile: ${_mobileController.text}
Email: ${_emailController.text.isEmpty ? 'Not provided' : _emailController.text}
Service: $_selectedService

I'm interested in your services.''';

      final url = Uri.parse(
        'https://wa.me/${widget.phoneNumber.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        _closePopup();
      }
    }
  }

  void _closePopup() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 40 : 60,
              ),
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 500,
                maxHeight: size.height * 0.9,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFBBF24).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 24 : 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFBBF24),
                                          Color(0xFFF59E0B),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '🎉 Special Offer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isMobile ? 11 : 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Get a Free Quote!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isMobile ? 22 : 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Connect with us on WhatsApp',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: isMobile ? 13 : 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _closePopup,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Enter your name',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          hint: '+91 XXXXX XXXXX',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email (Optional)',
                          hint: 'your@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(),
                        const SizedBox(height: 28),
                        _buildSubmitButton(isMobile),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Your information is secure',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFBBF24),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white38),
            prefixIcon: Icon(icon, color: const Color(0xFFFBBF24)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFBBF24), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Service',
          style: TextStyle(
            color: Color(0xFFFBBF24),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedService,
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFFFBBF24),
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.build_outlined,
                color: Color(0xFFFBBF24),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _services.map((String service) {
              return DropdownMenuItem<String>(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedService = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFBBF24).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _submitForm,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Submit via WhatsApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
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

// =====================================================
// NAVIGATION COMPONENTS
// =====================================================
class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({required this.icon, required this.label});
}

class FloatingNavigationBar extends StatefulWidget {
  final List<NavigationItem> items;
  final int activeIndex;
  final Function(int) onTap;

  const FloatingNavigationBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavigationBar> createState() => _FloatingNavigationBarState();
}

class _FloatingNavigationBarState extends State<FloatingNavigationBar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    if (isMobile) {
      return _buildMobileNav();
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
          ),
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: const Color(0xFFFBBF24).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: const Color(0xFFFBBF24).withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.items.length,
            (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.items.length,
            (index) => _buildMobileNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = widget.activeIndex == index;
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  )
                : null,
            color: isActive
                ? null
                : isHovered
                ? const Color(0xFF2D2D2D)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFBBF24).withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.items[index].icon,
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                size: 18,
              ),
              if (isActive || isHovered) ...[
                const SizedBox(width: 8),
                Text(
                  widget.items[index].label,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(int index) {
    final isActive = widget.activeIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                )
              : null,
          color: isActive ? null : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          widget.items[index].icon,
          color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          size: 16,
        ),
      ),
    );
  }
}

// =====================================================
// SCROLL PROGRESS INDICATOR
// =====================================================
class ScrollProgressIndicator extends StatelessWidget {
  final ScrollController controller;
  final int activeSection;
  final int totalSections;
  final Function(int) onTap;

  const ScrollProgressIndicator({
    super.key,
    required this.controller,
    required this.activeSection,
    required this.totalSections,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          totalSections,
          (index) => GestureDetector(
            onTap: () => onTap(index),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                width: 8,
                height: activeSection == index ? 32 : 8,
                decoration: BoxDecoration(
                  gradient: activeSection == index
                      ? const LinearGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        )
                      : null,
                  color: activeSection == index
                      ? null
                      : const Color(0xFF4B5563),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: activeSection == index
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// HELPER WIDGETS
// =====================================================
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? color;

  const SectionWrapper({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color ?? Colors.black,
      child: child,
    );
  }
}

class SectionPlaceholder extends StatelessWidget {
  final double height;

  const SectionPlaceholder({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFFFBBF24).withOpacity(0.3),
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final bool visible;

  const AnimatedReveal({super.key, required this.child, this.visible = true});

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _controller.forward();
    }
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
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
