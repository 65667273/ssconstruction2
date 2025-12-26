import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ss/first.dart';
import 'package:ss/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ss/MachinerySection.dart';
import 'package:ss/about.dart';
import 'package:ss/contact.dart';
import 'package:ss/new.dart';
import 'package:ss/new2.dart';
import 'package:ss/servies.dart';
import 'package:ss/sho.dart';

class ModernLandingPage extends StatefulWidget {
  const ModernLandingPage({super.key});

  @override
  State<ModernLandingPage> createState() => _ModernLandingPageState();
}

class _ModernLandingPageState extends State<ModernLandingPage>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _heroController;

  // Section Keys
  final List<GlobalKey> _sectionKeys = List.generate(
    13,
    (index) => GlobalKey(),
  );

  // Navigation items
  final List<NavigationItem> _navItems = const [
    NavigationItem(icon: Icons.home, label: 'Home', color: Color(0xFFFBBF24)),
    NavigationItem(
      icon: Icons.info_outline,
      label: 'About',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.construction_outlined,
      label: 'Road Roller',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.work_outline,
      label: 'Projects',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.construction,
      label: 'How We Work',
      color: Color(0xFFFF9500),
    ),
    NavigationItem(
      icon: Icons.precision_manufacturing,
      label: 'Machinery',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.verified,
      label: 'Quality',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(icon: Icons.groups, label: 'Team', color: Color(0xFFFBBF24)),
    NavigationItem(
      icon: Icons.photo_library,
      label: 'Media',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.thumb_up_outlined,
      label: 'Why Choose Us',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.star_outline,
      label: 'Features',
      color: Color(0xFFFBBF24),
    ),
    NavigationItem(
      icon: Icons.contact_mail,
      label: 'Contact',
      color: Color(0xFFFBBF24),
    ),
  ];

  bool _showNavBar = false;
  bool _showPopup = false;
  int _activeSection = 0;
  bool _isScrolling = false;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        _onScroll();
        _updateScrollProgress();
      });

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Show navbar after hero animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showNavBar = true);
    });

    // Show popup after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) setState(() => _showPopup = true);
    });
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress = maxScroll > 0 ? currentScroll / maxScroll : 0;
      });
    }
  }

  void _onScroll() {
    if (_isScrolling) return;

    final scrollPosition = _scrollController.position.pixels;
    int newActiveSection = 0;

    // Calculate active section based on scroll position
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);

        // Check if section is in viewport (with 150px offset for navbar)
        if (position.dy <= 150) {
          newActiveSection = i;
          break;
        }
      }
    }

    if (_activeSection != newActiveSection) {
      setState(() => _activeSection = newActiveSection);
    }
  }

  Future<void> _scrollToSection(int index) async {
    if (_isScrolling || index < 0 || index >= _sectionKeys.length) return;

    setState(() => _isScrolling = true);
    setState(() => _activeSection = index);

    final key = _sectionKeys[index];
    final context = key.currentContext;

    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
        alignment: 0.1, // Slight offset from top
      );
    }

    // Reset scrolling state
    Future.delayed(const Duration(milliseconds: 850), () {
      if (mounted) setState(() => _isScrolling = false);
    });
  }

  Widget _buildModernHeroSection() {
    return ModernHeroSection(
      key: _sectionKeys[0],
      isMobile: MediaQuery.of(context).size.width < 600,
      isTablet:
          MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 900,
      scrollToSection: _scrollToSection,
      heroController: _heroController,
    );
  }

  Widget _buildSection(int index, Widget child, {Color? backgroundColor}) {
    return SectionWrapper(
      key: _sectionKeys[index],
      backgroundColor: backgroundColor,
      index: index,
      activeSection: _activeSection,
      child: AnimatedReveal(
        visible: _activeSection >= index - 1,
        delay: index * 100,
        child: child,
      ),
    );
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
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Modern Hero Section
                _buildModernHeroSection(),

                // 2. About Section
                _buildSection(1, const AboutSection()),

                // 3. Road Roller Page
                _buildSection(2, const RoadRollerPage()),

                // 4. Projects Section
                _buildSection(3, const ProjectsSection()),

                // 5. How We Work Section
                _buildSection(
                  4,
                  const HowWeWorkSection(),
                  backgroundColor: const Color(0xFF060606),
                ),

                // 6. Machinery Section
                _buildSection(5, const MachinerySection()),

                // 7. Quality Standards Section
                _buildSection(6, const QualityStandardsSection()),

                // 8. Team Strength Section
                _buildSection(7, const TeamStrengthSection()),

                // 9. Media Gallery Section
                _buildSection(8, const MediaGallerySection()),

                // 10. Why Choose SS Section
                _buildSection(9, const WhyChooseSSSection()),

                // 11. Interactive Features Section
                _buildSection(10, const InteractiveFeaturesSection()),

                // 12. Contact Section
                _buildSection(
                  11,
                  const ContactSection(),
                  backgroundColor: const Color(0xFF060606),
                ),

                // Footer
                _buildFooter(),
              ],
            ),
          ),

          // Modern Navigation Bar
          if (!isMobile)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 500),
                offset: _showNavBar ? Offset.zero : const Offset(0, -2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _showNavBar ? 1 : 0,
                  child: ModernNavigationBar(
                    items: _navItems,
                    activeIndex: _activeSection,
                    onTap: _scrollToSection,
                    isScrolling: _isScrolling,
                  ),
                ),
              ),
            ),

          // Mobile Navigation
          if (isMobile)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _showNavBar ? 1 : 0,
                child: MobileNavigationBar(
                  items: _navItems,
                  activeIndex: _activeSection,
                  onTap: _scrollToSection,
                  isScrolling: _isScrolling,
                ),
              ),
            ),

          // Scroll Progress Bar
          if (!isMobile)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                color: Colors.transparent,
                child: LinearProgressIndicator(
                  value: _scrollProgress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _navItems[_activeSection].color.withOpacity(0.7),
                  ),
                ),
              ),
            ),

          // Scroll Indicator
          if (!isMobile)
            Positioned(
              right: 20,
              top: 100,
              bottom: 100,
              child: AnimatedFloatingIndicator(
                activeSection: _activeSection,
                totalSections: 12,
                onTap: _scrollToSection,
                isScrolling: _isScrolling,
              ),
            ),

          // Floating WhatsApp Button
          Positioned(
            right: 20,
            bottom: 20,
            child: AnimatedWhatsAppButton(
              phoneNumber: '+919823388866',
              show: _showNavBar,
            ),
          ),

          // Back to Top Button
          if (_scrollProgress > 0.1 && !isMobile)
            Positioned(
              left: 20,
              bottom: 20,
              child: AnimatedBackToTopButton(onTap: () => _scrollToSection(0)),
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, const Color(0xFF0F0F0F)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            '© 2024 SS Construction — All rights reserved',
            style: TextStyle(color: Colors.white54, fontSize: 14),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final url = Uri.parse('https://facebook.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.facebook, color: Colors.white54),
              ),
              IconButton(
                onPressed: () async {
                  final url = Uri.parse('https://instagram.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.chat, color: Colors.white54),
              ),
              IconButton(
                onPressed: () async {
                  final url = Uri.parse('https://linkedin.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.linked_camera, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroController.dispose();
    super.dispose();
  }
}

// =====================================================
// MODERN NAVIGATION BAR
// =====================================================
class ModernNavigationBar extends StatefulWidget {
  final List<NavigationItem> items;
  final int activeIndex;
  final Function(int) onTap;
  final bool isScrolling;

  const ModernNavigationBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTap,
    required this.isScrolling,
  });

  @override
  State<ModernNavigationBar> createState() => _ModernNavigationBarState();
}

class _ModernNavigationBarState extends State<ModernNavigationBar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(50),
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
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Navigation Items
            Flexible(
              child: Row(
                children: List.generate(
                  widget.items.length,
                  (index) => _buildNavItem(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = widget.activeIndex == index;
    final isHovered = _hoveredIndex == index;
    final isExpanded =
        isActive || isHovered; // Show label when active or hovered
    final item = widget.items[index];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get screen width for responsive behavior
        final screenWidth = MediaQuery.of(context).size.width;

        // Responsive breakpoints
        final bool isMobile = screenWidth < 600;
        final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

        // Responsive values
        final double horizontalMargin = isMobile
            ? 2.0
            : isTablet
            ? 3.0
            : 4.0;
        final double collapsedPadding = isMobile
            ? 8.0
            : isTablet
            ? 10.0
            : 12.0;
        final double expandedPadding = isMobile
            ? 12.0
            : isTablet
            ? 16.0
            : 20.0;
        final double verticalPadding = isMobile ? 10.0 : 12.0;
        final double iconSize = isMobile
            ? 16.0
            : isTablet
            ? 17.0
            : 18.0;
        final double spacing = isMobile
            ? 6.0
            : isTablet
            ? 7.0
            : 8.0;
        final double fontSize = isMobile
            ? 12.0
            : isTablet
            ? 13.0
            : 14.0;
        final double borderRadius = isMobile
            ? 30.0
            : isTablet
            ? 35.0
            : 40.0;
        final double blurRadius = isMobile
            ? 10.0
            : isTablet
            ? 12.0
            : 15.0;

        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredIndex = index),
          onExit: (_) => setState(() => _hoveredIndex = null),
          child: GestureDetector(
            onTap: () => widget.onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? expandedPadding : collapsedPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [item.color, item.color.withOpacity(0.8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isActive
                    ? null
                    : isHovered
                    ? item.color.withOpacity(isMobile ? 0.08 : 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: item.color.withOpacity(0.5),
                          blurRadius: blurRadius,
                          spreadRadius: isMobile ? 1.5 : 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
                border: isActive && isMobile
                    ? Border.all(color: item.color, width: 1.5)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon with proper alignment
                  Icon(
                    item.icon,
                    color: isActive
                        ? Colors.white
                        : item.color.withOpacity(0.8),
                    size: iconSize,
                  ),

                  // Conditional label with smooth animation
                  if (isExpanded) ...[
                    SizedBox(width: spacing),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isExpanded ? 1.0 : 0.0,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : item.color.withOpacity(0.9),
                          fontSize: fontSize,
                          fontWeight: isMobile
                              ? FontWeight.w500
                              : FontWeight.w600,
                          letterSpacing: isMobile ? 0.2 : 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================
// MOBILE NAVIGATION BAR
// =====================================================
class MobileNavigationBar extends StatefulWidget {
  final List<NavigationItem> items;
  final int activeIndex;
  final Function(int) onTap;
  final bool isScrolling;

  const MobileNavigationBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTap,
    required this.isScrolling,
  });

  @override
  State<MobileNavigationBar> createState() => _MobileNavigationBarState();
}

class _MobileNavigationBarState extends State<MobileNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () => widget.onTap(0),
            child: const Text(
              'SS',
              style: TextStyle(
                color: Color(0xFFFBBF24),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          // Menu Button
          PopupMenuButton<int>(
            icon: Icon(
              Icons.menu,
              color: widget.items[widget.activeIndex].color,
            ),
            color: Colors.black,
            surfaceTintColor: Colors.black,
            onSelected: widget.onTap,
            itemBuilder: (context) {
              return widget.items.map((item) {
                final index = widget.items.indexOf(item);
                return PopupMenuItem<int>(
                  value: index,
                  child: Row(
                    children: [
                      Icon(item.icon, color: item.color),
                      const SizedBox(width: 12),
                      Text(item.label, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ANIMATED FLOATING INDICATOR
// =====================================================
class AnimatedFloatingIndicator extends StatefulWidget {
  final int activeSection;
  final int totalSections;
  final Function(int) onTap;
  final bool isScrolling;

  const AnimatedFloatingIndicator({
    super.key,
    required this.activeSection,
    required this.totalSections,
    required this.onTap,
    required this.isScrolling,
  });

  @override
  State<AnimatedFloatingIndicator> createState() =>
      _AnimatedFloatingIndicatorState();
}

class _AnimatedFloatingIndicatorState extends State<AnimatedFloatingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFBBF24).withOpacity(0.2),
              ),
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
                widget.totalSections,
                (index) => GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      width: 8,
                      height: widget.activeSection == index ? 32 : 8,
                      decoration: BoxDecoration(
                        gradient: widget.activeSection == index
                            ? const LinearGradient(
                                colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                              )
                            : null,
                        color: widget.activeSection == index
                            ? null
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: widget.activeSection == index
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFBBF24,
                                  ).withOpacity(0.5),
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
          ),
        );
      },
    );
  }
}

// =====================================================
// ANIMATED WHATSAPP BUTTON
// =====================================================
class AnimatedWhatsAppButton extends StatefulWidget {
  final String phoneNumber;
  final bool show;

  const AnimatedWhatsAppButton({
    super.key,
    required this.phoneNumber,
    required this.show,
  });

  @override
  State<AnimatedWhatsAppButton> createState() => _AnimatedWhatsAppButtonState();
}

class _AnimatedWhatsAppButtonState extends State<AnimatedWhatsAppButton>
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
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      offset: widget.show ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: widget.show ? 1 : 0,
        child: ScaleTransition(
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
        ),
      ),
    );
  }
}

// =====================================================
// ANIMATED BACK TO TOP BUTTON
// =====================================================
class AnimatedBackToTopButton extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedBackToTopButton({super.key, required this.onTap});

  @override
  State<AnimatedBackToTopButton> createState() =>
      _AnimatedBackToTopButtonState();
}

class _AnimatedBackToTopButtonState extends State<AnimatedBackToTopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFBBF24).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: const Color(0xFFFBBF24),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: widget.onTap,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// SECTION WRAPPER WITH ANIMATION
// =====================================================
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final int index;
  final int activeSection;

  const SectionWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    required this.index,
    required this.activeSection,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeSection == index;
    final isNearby = (activeSection - index).abs() <= 1;

    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.black,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isNearby ? 1.0 : 0.3,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: isActive ? 1.0 : 0.98,
          child: child,
        ),
      ),
    );
  }
}

// =====================================================
// ANIMATED REVEAL
// =====================================================
class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final bool visible;
  final int delay;

  const AnimatedReveal({
    super.key,
    required this.child,
    this.visible = true,
    this.delay = 0,
  });

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    if (widget.visible) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // Handle form submission
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFBBF24).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Get In Touch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We\'d love to hear from you. Send us a message!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Your Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Message Field
                  _buildTextField(
                    controller: _messageController,
                    label: 'Message',
                    icon: Icons.message_outlined,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFBBF24).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _handleSubmit,
                          borderRadius: BorderRadius.circular(12),
                          child: const Center(
                            child: Text(
                              'Send Message',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
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
      ),
    );
  }
}

// =====================================================
// DATA MODELS
// =====================================================
class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}
