import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// DATA MODELS
// ============================================================================

class ProjectProgress {
  final String name;
  final double progress;
  final IconData icon;
  final Color color;

  ProjectProgress({
    required this.name,
    required this.progress,
    required this.icon,
    required this.color,
  });
}

class Testimonial {
  final String name;
  final String location;
  final String review;
  final int rating;
  final String image;

  Testimonial({
    required this.name,
    required this.location,
    required this.review,
    required this.rating,
    required this.image,
  });
}

class BlogPost {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;

  BlogPost({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
  });
}

// ============================================================================
// RESPONSIVE HELPER
// ============================================================================

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 16;
    if (isTablet(context)) return 32;
    return 60;
  }

  static double getResponsiveFontSize(BuildContext context, double base) {
    if (isMobile(context)) return base * 0.8;
    if (isTablet(context)) return base * 0.9;
    return base;
  }
}

// ============================================================================
// MAIN INTERACTIVE FEATURES SECTION
// ============================================================================

class InteractiveFeaturesSection extends StatefulWidget {
  const InteractiveFeaturesSection({super.key});

  @override
  State<InteractiveFeaturesSection> createState() =>
      _InteractiveFeaturesSectionState();
}

class _InteractiveFeaturesSectionState extends State<InteractiveFeaturesSection>
    with TickerProviderStateMixin {
  late AnimationController _machineController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _machineController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _machineController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = ResponsiveHelper.getResponsivePadding(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0F172A),
            const Color(0xFF1E293B),
            const Color(0xFF0F172A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Construction Machines Background
          _buildAnimatedMachines(),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 80,
                horizontal: padding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: isMobile ? 40 : 60),

                      // Progress Tracker
                      const ProgressTrackerWidget(),
                      SizedBox(height: isMobile ? 40 : 60),

                      // Blog/Knowledge Section
                      const BlogKnowledgeWidget(),
                      SizedBox(height: isMobile ? 40 : 60),

                      // Testimonial Carousel
                      const TestimonialCarouselWidget(),
                      SizedBox(height: isMobile ? 30 : 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMachines() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _machineController,
        builder: (context, child) {
          return CustomPaint(
            painter: ConstructionMachinesPainter(
              animationValue: _machineController.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final baseFontSize = isMobile ? 32.0 : 48.0;

    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _fadeController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: 8,
              ),
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
                'INTERACTIVE TOOLS',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAAB0C),
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [Colors.white, const Color(0xFFFAAB0C), Colors.white],
                ).createShader(bounds);
              },
              child: Text(
                'Explore Our Features',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Interactive tools designed to make your property journey easier',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookSiteVisit() {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: _isVisible ? 1.0 : 0.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 30 : 50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981),
                        const Color(0xFF059669),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isMobile ? 20 : 30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF10B981,
                        ).withOpacity(0.3 + (0.2 * _pulseController.value)),
                        blurRadius: 30 + (10 * _pulseController.value),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: isMobile ? 36 : 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: isMobile ? 15 : 20),
                      Text(
                        'Book a Site Visit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isMobile ? 10 : 15),
                      Text(
                        'Schedule an instant visit via WhatsApp',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 30),
                      ElevatedButton.icon(
                        onPressed: _launchWhatsApp,
                        icon: Icon(Icons.chat, size: isMobile ? 20 : 28),
                        label: Text(
                          isMobile
                              ? 'Schedule Now'
                              : 'Schedule Now on WhatsApp',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF10B981),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 40,
                            vertical: isMobile ? 16 : 22,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _launchWhatsApp() async {
    const message = "Hi! I'd like to schedule a site visit at SS Construction.";
    final url = Uri.parse(
      'https://wa.me/918698230709?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

// ============================================================================
// PROGRESS TRACKER WIDGET
// ============================================================================

class ProgressTrackerWidget extends StatefulWidget {
  const ProgressTrackerWidget({super.key});

  @override
  State<ProgressTrackerWidget> createState() => _ProgressTrackerWidgetState();
}

class _ProgressTrackerWidgetState extends State<ProgressTrackerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  final List<ProjectProgress> projects = [
    ProjectProgress(
      name: 'Road Construction',
      progress: 0.80,
      icon: Icons.route,
      color: const Color(0xFF3B82F6),
    ),
    ProjectProgress(
      name: 'Electrification',
      progress: 0.60,
      icon: Icons.electrical_services,
      color: const Color(0xFFFAAB0C),
    ),
    ProjectProgress(
      name: 'Water Supply',
      progress: 0.75,
      icon: Icons.water_drop,
      color: const Color(0xFF06B6D4),
    ),
    ProjectProgress(
      name: 'Drainage System',
      progress: 0.65,
      icon: Icons.water,
      color: const Color(0xFF8B5CF6),
    ),
    ProjectProgress(
      name: 'Street Lighting',
      progress: 0.85,
      icon: Icons.light,
      color: const Color(0xFFF59E0B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 20 : 30),
                border: Border.all(
                  color: const Color(0xFFFAAB0C).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 8 : 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3B82F6),
                              const Color(0xFF60A5FA),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: isMobile ? 20 : 28,
                        ),
                      ),
                      Text(
                        'Project Progress Tracker',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 25 : 40),
                  ...projects
                      .map((project) => _buildProgressBar(project))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(ProjectProgress project) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile ? 20 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: project.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  project.icon,
                  color: project.color,
                  size: isMobile ? 16 : 20,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Text(
                  project.name,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final displayProgress =
                      project.progress * _progressController.value;
                  return Text(
                    '${(displayProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.w900,
                      color: project.color,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Container(
                height: isMobile ? 10 : 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: project.progress * _progressController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [project.color, project.color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: project.color.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMI CALCULATOR WIDGET
// ============================================================================

class EMICalculatorWidget extends StatefulWidget {
  const EMICalculatorWidget({super.key});

  @override
  State<EMICalculatorWidget> createState() => _EMICalculatorWidgetState();
}

class _EMICalculatorWidgetState extends State<EMICalculatorWidget>
    with SingleTickerProviderStateMixin {
  double _loanAmount = 1000000;
  double _interestRate = 8.5;
  double _tenure = 15;
  double _emi = 0;
  late AnimationController _emiAnimController;

  @override
  void initState() {
    super.initState();
    _emiAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _calculateEMI();
  }

  @override
  void dispose() {
    _emiAnimController.dispose();
    super.dispose();
  }

  void _calculateEMI() {
    double monthlyRate = _interestRate / (12 * 100);
    double months = _tenure * 12;

    if (monthlyRate == 0) {
      _emi = _loanAmount / months;
    } else {
      _emi =
          _loanAmount *
          monthlyRate *
          math.pow(1 + monthlyRate, months) /
          (math.pow(1 + monthlyRate, months) - 1);
    }

    _emiAnimController.reset();
    _emiAnimController.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final totalPayment = _emi * _tenure * 12;
    final totalInterest = totalPayment - _loanAmount;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFAAB0C).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 20 : 30),
                border: Border.all(
                  color: const Color(0xFFFAAB0C).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 8 : 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFAAB0C),
                              Colors.yellow.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calculate,
                          color: Colors.black,
                          size: isMobile ? 20 : 28,
                        ),
                      ),
                      Text(
                        'EMI Calculator',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 25 : 40),

                  _buildSlider(
                    label: 'Loan Amount',
                    value: _loanAmount,
                    min: 100000,
                    max: 10000000,
                    divisions: 99,
                    displayValue:
                        '₹${(_loanAmount / 100000).toStringAsFixed(1)}L',
                    onChanged: (val) {
                      setState(() => _loanAmount = val);
                      _calculateEMI();
                    },
                  ),

                  SizedBox(height: isMobile ? 20 : 30),

                  _buildSlider(
                    label: 'Interest Rate (p.a.)',
                    value: _interestRate,
                    min: 1,
                    max: 20,
                    divisions: 190,
                    displayValue: '${_interestRate.toStringAsFixed(1)}%',
                    onChanged: (val) {
                      setState(() => _interestRate = val);
                      _calculateEMI();
                    },
                  ),

                  SizedBox(height: isMobile ? 20 : 30),

                  _buildSlider(
                    label: 'Loan Tenure',
                    value: _tenure,
                    min: 1,
                    max: 30,
                    divisions: 29,
                    displayValue: '${_tenure.toInt()} Years',
                    onChanged: (val) {
                      setState(() => _tenure = val);
                      _calculateEMI();
                    },
                  ),

                  SizedBox(height: isMobile ? 30 : 40),

                  AnimatedBuilder(
                    animation: _emiAnimController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.9 + (0.1 * _emiAnimController.value),
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 20 : 30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFAAB0C),
                                Colors.yellow.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              isMobile ? 15 : 20,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFAAB0C).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Monthly EMI',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: isMobile ? 8 : 10),
                              Text(
                                '₹${_emi.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: isMobile ? 28 : 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: isMobile ? 15 : 20),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: isMobile ? 15 : 20,
                                runSpacing: 15,
                                children: [
                                  _buildEMIDetail(
                                    'Principal',
                                    '₹${(_loanAmount / 100000).toStringAsFixed(1)}L',
                                  ),
                                  if (!isMobile)
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: Colors.black26,
                                    ),
                                  _buildEMIDetail(
                                    'Interest',
                                    '₹${(totalInterest / 100000).toStringAsFixed(1)}L',
                                  ),
                                  if (!isMobile)
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: Colors.black26,
                                    ),
                                  _buildEMIDetail(
                                    'Total',
                                    '₹${(totalPayment / 100000).toStringAsFixed(1)}L',
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 12,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFAAB0C).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFAAB0C), width: 1),
              ),
              child: Text(
                displayValue,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFAAB0C),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 8 : 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFFFAAB0C),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            thumbColor: const Color(0xFFFAAB0C),
            overlayColor: const Color(0xFFFAAB0C).withOpacity(0.3),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: isMobile ? 10 : 12,
            ),
            trackHeight: isMobile ? 6 : 8,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildEMIDetail(String label, String value) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BLOG/KNOWLEDGE WIDGET
// ============================================================================

class BlogKnowledgeWidget extends StatelessWidget {
  const BlogKnowledgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final blogs = [
      BlogPost(
        title: 'Understanding NMRDA Approvals',
        description: 'Complete guide to NMRDA regulations and approval process',
        icon: Icons.verified,
        color: const Color(0xFF3B82F6),
        category: 'Legal',
      ),
      BlogPost(
        title: 'Plot Buying Checklist',
        description: 'Essential tips for first-time plot buyers',
        icon: Icons.checklist,
        color: const Color(0xFF10B981),
        category: 'Guide',
      ),
      BlogPost(
        title: 'Legal Documentation Guide',
        description: 'Understanding property documents and registration',
        icon: Icons.description,
        color: const Color(0xFF8B5CF6),
        category: 'Legal',
      ),
      BlogPost(
        title: 'Investment Tips for 2025',
        description: 'Smart strategies for property investment',
        icon: Icons.trending_up,
        color: const Color(0xFFFAAB0C),
        category: 'Investment',
      ),
    ];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 20 : 30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 8 : 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF8B5CF6),
                              const Color(0xFFA78BFA),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: isMobile ? 20 : 28,
                        ),
                      ),
                      Text(
                        'Knowledge Center',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 25 : 40),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      if (constraints.maxWidth >= 1200) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth >= 768) {
                        crossAxisCount = 2;
                      }

                      if (isMobile) {
                        return Column(
                          children: blogs
                              .asMap()
                              .entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: _BlogCard(
                                    blog: entry.value,
                                    delay: entry.key * 200,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: blogs
                            .asMap()
                            .entries
                            .map(
                              (entry) => _BlogCard(
                                blog: entry.value,
                                delay: entry.key * 200,
                              ),
                            )
                            .toList(),
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
}

class _BlogCard extends StatefulWidget {
  final BlogPost blog;
  final int delay;

  const _BlogCard({required this.blog, this.delay = 0});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _entryController.value),
          child: Opacity(
            opacity: _entryController.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onTap: () {
                  setState(() => _isHovered = !_isHovered);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isMobile ? double.infinity : 300,
                  height: 300,
                  transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isHovered
                          ? [
                              widget.blog.color.withOpacity(0.2),
                              widget.blog.color.withOpacity(0.05),
                            ]
                          : [
                              Colors.white.withOpacity(0.05),
                              Colors.white.withOpacity(0.02),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isHovered
                          ? widget.blog.color.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: widget.blog.color.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.blog.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                widget.blog.icon,
                                color: widget.blog.color,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.blog.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: widget.blog.color),
                              ),
                              child: Text(
                                widget.blog.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: widget.blog.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.blog.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.blog.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              'Read More',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: widget.blog.color,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: widget.blog.color,
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
        );
      },
    );
  }
}

// ============================================================================
// TESTIMONIAL CAROUSEL WIDGET
// ============================================================================

class TestimonialCarouselWidget extends StatefulWidget {
  const TestimonialCarouselWidget({super.key});

  @override
  State<TestimonialCarouselWidget> createState() =>
      _TestimonialCarouselWidgetState();
}

class _TestimonialCarouselWidgetState extends State<TestimonialCarouselWidget>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _autoPlayController;
  int _currentPage = 0;

  final List<Testimonial> testimonials = [
    Testimonial(
      name: 'Rajesh Kumar',
      location: 'Wardha',
      review:
          'Excellent service! SS Construction delivered our plot with all NMRDA approvals on time. The transparency in documentation was impressive.',
      rating: 5,
      image: '👨‍💼',
    ),
    Testimonial(
      name: 'Priya Sharma',
      location: 'Nagpur',
      review:
          'Very professional team. They guided us through the entire legal process and made plot buying hassle-free. Highly recommended!',
      rating: 5,
      image: '👩‍💼',
    ),
    Testimonial(
      name: 'Amit Deshmukh',
      location: 'Wardha',
      review:
          'Quality work and timely delivery. The infrastructure development is top-notch. Best decision to invest with SS Construction.',
      rating: 5,
      image: '👨‍💻',
    ),
    Testimonial(
      name: 'Sneha Patil',
      location: 'Nagpur',
      review:
          'Outstanding experience! From site visit to documentation, everything was smooth. The team is very helpful and responsive.',
      rating: 5,
      image: '👩‍🎓',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final isMobile =
        MediaQueryData.fromView(WidgetsBinding.instance.window).size.width <
        768;
    _pageController = PageController(viewportFraction: isMobile ? 0.9 : 0.85);
    _autoPlayController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _autoPlayController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_currentPage < testimonials.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoPlayController.reset();
        _autoPlayController.forward();
      }
    });

    _autoPlayController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoPlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMobile ? 8 : 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFAAB0C),
                            Colors.yellow.shade700,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.rate_review,
                        color: Colors.black,
                        size: isMobile ? 20 : 28,
                      ),
                    ),
                    Text(
                      'Client Testimonials',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 25 : 40),
                SizedBox(
                  height: isMobile ? 400 : 320,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _autoPlayController.reset();
                      _autoPlayController.forward();
                    },
                    itemCount: testimonials.length,
                    itemBuilder: (context, index) {
                      return _TestimonialCard(
                        testimonial: testimonials[index],
                        isActive: index == _currentPage,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    testimonials.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFFAAB0C)
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;
  final bool isActive;

  const _TestimonialCard({required this.testimonial, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 10),
          padding: EdgeInsets.all(isMobile ? 20 : 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFAAB0C).withOpacity(0.15),
                const Color(0xFFFAAB0C).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFFFAAB0C).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFAAB0C).withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.8),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: isMobile ? 70 : 80,
                      height: isMobile ? 70 : 80,
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
                            color: const Color(0xFFFAAB0C).withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          testimonial.image,
                          style: TextStyle(fontSize: isMobile ? 35 : 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isMobile ? 15 : 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.5),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          index < testimonial.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFAAB0C),
                          size: isMobile ? 20 : 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 12 : 15),

              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '"${testimonial.review}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 15,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 15 : 20),

              Text(
                testimonial.name,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    size: isMobile ? 14 : 16,
                    color: const Color(0xFFFAAB0C),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    testimonial.location,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CONSTRUCTION MACHINES BACKGROUND PAINTER
// ============================================================================

class ConstructionMachinesPainter extends CustomPainter {
  final double animationValue;

  ConstructionMachinesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Animated grid background
    for (int i = 0; i < 12; i++) {
      final offset = (animationValue * 80) % 80;
      final y = (size.height / 12) * i + offset;
      paint.color = Colors.white.withOpacity(0.02);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // JCB/Excavator animation (top left)
    _drawJCB(canvas, size, paint);

    // Roller animation (top right)
    _drawRoller(canvas, size, paint);

    // Mixer animation (bottom center)
    _drawMixer(canvas, size, paint);

    // Floating particles
    _drawFloatingParticles(canvas, size, paint);
  }

  void _drawJCB(Canvas canvas, Size size, Paint paint) {
    final progress = animationValue;
    final x = 100 + (math.sin(progress * 2 * math.pi) * 50);
    final y = 150 + (math.cos(progress * 2 * math.pi) * 20);

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFFAAB0C).withOpacity(0.1);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, 60, 40),
        const Radius.circular(8),
      ),
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    paint.color = const Color(0xFFFAAB0C).withOpacity(0.2);
    final armAngle = math.sin(progress * 4 * math.pi) * 0.3;
    canvas.drawLine(
      Offset(x + 50, y + 20),
      Offset(
        x + 50 + math.cos(armAngle) * 40,
        y + 20 - math.sin(armAngle) * 40,
      ),
      paint,
    );
  }

  void _drawRoller(Canvas canvas, Size size, Paint paint) {
    final progress = animationValue;
    final x = size.width - 150 - (progress * 100 % 100);
    final y = 150.0;

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF3B82F6).withOpacity(0.1);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, 50, 30),
        const Radius.circular(6),
      ),
      paint,
    );

    paint.color = const Color(0xFF3B82F6).withOpacity(0.15);
    canvas.drawCircle(Offset(x + 25, y + 40), 15, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = const Color(0xFF3B82F6).withOpacity(0.2);
    final angle = progress * 4 * math.pi;
    canvas.drawLine(
      Offset(x + 25, y + 40),
      Offset(x + 25 + math.cos(angle) * 12, y + 40 + math.sin(angle) * 12),
      paint,
    );
  }

  void _drawMixer(Canvas canvas, Size size, Paint paint) {
    final progress = animationValue;
    final x = size.width / 2;
    final y = size.height - 200;

    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFF10B981).withOpacity(0.1);

    final rotation = progress * 2 * math.pi;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 50, height: 35),
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.color = const Color(0xFF10B981).withOpacity(0.2);
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      canvas.drawLine(
        Offset.zero,
        Offset(math.cos(angle) * 20, math.sin(angle) * 20),
        paint,
      );
    }
    canvas.restore();
  }

  void _drawFloatingParticles(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final angle = (animationValue + i / 15) * 2 * math.pi;
      final x = size.width / 2 + math.cos(angle) * (size.width * 0.4);
      final y = size.height / 2 + math.sin(angle * 1.5) * (size.height * 0.3);
      final opacity = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2;

      paint.color = const Color(0xFFFAAB0C).withOpacity(0.05 * opacity);
      canvas.drawCircle(Offset(x, y), 3 + (opacity * 2), paint);
    }
  }

  @override
  bool shouldRepaint(ConstructionMachinesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
