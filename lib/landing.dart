import 'dart:math';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ss/MachinerySection.dart';
import 'package:ss/about.dart';
import 'package:ss/contact.dart';
import 'package:ss/main.dart';
import 'package:ss/new.dart';
import 'package:ss/new2.dart';
import 'package:ss/servies.dart';
import 'package:ss/sho.dart';
// Add this import

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _heroController;
  late final AnimationController _introController;

  // Section Keys for Navigation
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _roadRollerKey = GlobalKey(); // Add this key
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _howWeWorkKey = GlobalKey();
  final GlobalKey _machineryKey = GlobalKey();
  final GlobalKey _qualityKey = GlobalKey();
  final GlobalKey _teamKey = GlobalKey();
  final GlobalKey _mediaKey = GlobalKey();
  final GlobalKey _whyChooseKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  // Section Visibility States
  Map<String, bool> _sectionVisibility = {
    'hero': true,
    'about': false,
    'roadRoller': false, // Add this
    'projects': false,
    'howWeWork': false,
    'machinery': false,
    'quality': false,
    'team': false,
    'media': false,
    'whyChoose': false,
    'features': false,
    'contact': false,
  };

  bool _modelsPreloaded = false;
  bool _showNavBar = false;
  int _activeSection = 0;

  final List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.info_outline, label: 'About'),
    NavigationItem(
      icon: Icons.construction_outlined,
      label: 'Road Roller',
    ), // Add this
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

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Preload models
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _modelsPreloaded = true);
    });

    // Show navbar after initial animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showNavBar = true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _heroController.dispose();
    _introController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Update section visibility for lazy loading
    setState(() {
      _sectionVisibility['about'] = offset > 200;
      _sectionVisibility['roadRoller'] = offset > 800; // Add this
      _sectionVisibility['projects'] = offset > 1500; // Updated
      _sectionVisibility['howWeWork'] = offset > 2300; // Updated
      _sectionVisibility['machinery'] = offset > 3100; // Updated
      _sectionVisibility['quality'] = offset > 3900; // Updated
      _sectionVisibility['team'] = offset > 4700; // Updated
      _sectionVisibility['media'] = offset > 5500; // Updated
      _sectionVisibility['whyChoose'] = offset > 6300; // Updated
      _sectionVisibility['features'] = offset > 7100; // Updated
      _sectionVisibility['contact'] = offset > 7900; // Updated

      // Update active section for navigation
      if (offset < 400) {
        _activeSection = 0;
      } else if (offset < 1100) {
        _activeSection = 1;
      } else if (offset < 1900) {
        _activeSection = 2; // Road Roller
      } else if (offset < 2700) {
        _activeSection = 3; // Projects
      } else if (offset < 3500) {
        _activeSection = 4; // How We Work
      } else if (offset < 4300) {
        _activeSection = 5; // Machinery
      } else if (offset < 5100) {
        _activeSection = 6; // Quality
      } else if (offset < 5900) {
        _activeSection = 7; // Team
      } else if (offset < 6700) {
        _activeSection = 8; // Media
      } else if (offset < 7500) {
        _activeSection = 9; // Why Choose
      } else if (offset < 8300) {
        _activeSection = 10; // Features
      } else {
        _activeSection = 11; // Contact
      }
    });
  }

  void _scrollToSection(GlobalKey key, int index) {
    setState(() => _activeSection = index);

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 900;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedBackground(controller: _heroController),
          ),

          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Hero Section
                SectionWrapper(
                  key: _heroKey,
                  child: _buildHeroSection(isNarrow),
                ),

                // 2. About Section
                SectionWrapper(
                  key: _aboutKey,
                  child: _sectionVisibility['about']!
                      ? AnimatedReveal(visible: true, child: AboutSection())
                      : const SectionPlaceholder(height: 600),
                ),

                // 3. Road Roller Section
                SectionWrapper(
                  key: _roadRollerKey,
                  child: _sectionVisibility['roadRoller']!
                      ? AnimatedReveal(visible: true, child: RoadRollerPage())
                      : const SectionPlaceholder(height: 700),
                ),

                // 4. Projects Section
                SectionWrapper(
                  key: _projectsKey,
                  child: _sectionVisibility['projects']!
                      ? AnimatedReveal(visible: true, child: ProjectsSection())
                      : const SectionPlaceholder(height: 800),
                ),

                // 5. How We Work Section
                SectionWrapper(
                  key: _howWeWorkKey,
                  color: const Color(0xFF060606),
                  child: _sectionVisibility['howWeWork']!
                      ? AnimatedReveal(visible: true, child: HowWeWorkSection())
                      : const SectionPlaceholder(height: 900),
                ),

                // 6. Machinery Section
                SectionWrapper(
                  key: _machineryKey,
                  child: _sectionVisibility['machinery']!
                      ? AnimatedReveal(visible: true, child: MachinerySection())
                      : const SectionPlaceholder(height: 700),
                ),

                // 7. Quality Standards Section
                SectionWrapper(
                  key: _qualityKey,
                  child: _sectionVisibility['quality']!
                      ? AnimatedReveal(
                          visible: true,
                          child: QualityStandardsSection(),
                        )
                      : const SectionPlaceholder(height: 600),
                ),

                // 8. Team Strength Section
                SectionWrapper(
                  key: _teamKey,
                  child: _sectionVisibility['team']!
                      ? AnimatedReveal(
                          visible: true,
                          child: TeamStrengthSection(),
                        )
                      : const SectionPlaceholder(height: 600),
                ),

                // 9. Media Gallery Section
                SectionWrapper(
                  key: _mediaKey,
                  child: _sectionVisibility['media']!
                      ? AnimatedReveal(
                          visible: true,
                          child: MediaGallerySection(),
                        )
                      : const SectionPlaceholder(height: 800),
                ),

                // 10. Why Choose Us Section
                SectionWrapper(
                  key: _whyChooseKey,
                  child: _sectionVisibility['whyChoose']!
                      ? AnimatedReveal(
                          visible: true,
                          child: WhyChooseSSSection(),
                        )
                      : const SectionPlaceholder(height: 700),
                ),

                // 11. Interactive Features Section
                SectionWrapper(
                  key: _featuresKey,
                  child: _sectionVisibility['features']!
                      ? AnimatedReveal(
                          visible: true,
                          child: InteractiveFeaturesSection(),
                        )
                      : const SectionPlaceholder(height: 600),
                ),

                // 12. Contact Section
                SectionWrapper(
                  key: _contactKey,
                  color: const Color(0xFF060606),
                  child: _sectionVisibility['contact']!
                      ? AnimatedReveal(visible: true, child: ContactSection())
                      : const SectionPlaceholder(height: 700),
                ),

                // Footer
                Container(
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
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
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
                ),
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
              onTap: (index) {
                final keys = [
                  _heroKey,
                  _aboutKey,
                  _roadRollerKey, // Add this
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
                _scrollToSection(keys[index], index);
              },
            ),
          ),

          // Scroll Progress Indicator
          Positioned(
            right: 20,
            top: 120,
            bottom: 100,
            child: ScrollProgressIndicator(
              controller: _scrollController,
              activeSection: _activeSection,
              totalSections: 12, // Updated from 11 to 12
              onTap: (index) {
                final keys = [
                  _heroKey,
                  _aboutKey,
                  _roadRollerKey, // Add this
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
                _scrollToSection(keys[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isNarrow) {
    return SizedBox(
      height: isNarrow ? 420 : 520,
      child: Stack(
        children: [
          Positioned.fill(child: HeroSpotlight(controller: _heroController)),
          Positioned.fill(child: ParticleSweep(controller: _heroController)),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 20 : 36,
                  vertical: isNarrow ? 18 : 30,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _introController,
                          _heroController,
                        ]),
                        builder: (context, child) {
                          final fade = Curves.easeOut.transform(
                            (_introController.value * 1.2).clamp(0.0, 1.0),
                          );
                          final slide = Curves.easeOutCubic.transform(
                            (_introController.value * 1.5).clamp(0.0, 1.0),
                          );
                          final floatVal = _heroController.value * 2 * pi;
                          final subtleFloat = 3 * sin(floatVal * 0.5);

                          return Opacity(
                            opacity: fade,
                            child: Transform.translate(
                              offset: Offset(-50 * (1 - slide), subtleFloat),
                              child: Transform.scale(
                                scale: 1.0 + 0.02 * sin(floatVal * 0.8),
                                child: HeroTextBlock(
                                  introController: _introController,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: isNarrow ? 6 : 8,
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildInstant3DModel(
                          src: 'assets/images/jcb_backhoe_loader.glb',
                          height: isNarrow ? 400 : 520,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstant3DModel({required String src, double height = 500}) {
    if (!_modelsPreloaded) {
      return SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ModelViewer(
        src: src,
        alt: "3D Construction Model",
        ar: true,
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
        backgroundColor: Colors.transparent,
        cameraOrbit: "45deg 90deg 50%",
        fieldOfView: "30deg",
        loading: Loading.lazy,
      ),
    );
  }
}

// ===================== NAVIGATION COMPONENTS =====================

class NavigationItem {
  final IconData icon;
  final String label;

  NavigationItem({required this.icon, required this.label});
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
                color: activeSection == index ? null : const Color(0xFF4B5563),
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
    );
  }
}

// ===================== HELPER WIDGETS =====================

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? color;

  const SectionWrapper({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, color: color, child: child);
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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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
