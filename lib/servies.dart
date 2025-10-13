import 'dart:math';
import 'package:flutter/material.dart';

class HowWeWorkSection extends StatefulWidget {
  const HowWeWorkSection({super.key});

  @override
  State<HowWeWorkSection> createState() => _HowWeWorkSectionState();
}

class _HowWeWorkSectionState extends State<HowWeWorkSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  int? _expandedIndex;

  final processes = [
    ProcessItem(
      title: 'Cement Road Construction',
      icon: Icons.construction,
      gradient: const [Color(0xFFFBBF24), Color(0xFFF59E0B)],
      steps: [
        'Site survey & soil testing',
        'Excavation & preparation of base',
        'Subgrade compaction using rollers',
        'Laying granular sub-base (GSB)',
        'Setting steel formwork for road edges',
        'Placing reinforcement mesh/steel',
        'Pouring high-grade cement concrete (M-30/M-35)',
        'Vibration using road vibrators & needle vibrators',
        'Surface finishing with fan floaters & trowel machines',
        'Curing process (watering, covering)',
        'Quality inspection & final handover',
      ],
      duration: '15-30 days',
      quality: 'M-30/M-35 Grade',
    ),
    ProcessItem(
      title: 'Sewer Line Work',
      icon: Icons.water_drop,
      gradient: const [Color(0xFFFCD34D), Color(0xFFFBBF24)],
      steps: [
        'Trenching with JCB & rollers',
        'Laying stone bedding',
        'Installation of RCC/Hume pipes (NP3/NP4 grade)',
        'Leak-proof jointing with collars & cement slurry',
        'Manhole chamber construction',
        'Backfilling & compaction',
        'Quality checks for flow',
      ],
      duration: '10-20 days',
      quality: 'NP3/NP4 Grade',
    ),
    ProcessItem(
      title: 'Electrification Work',
      icon: Icons.bolt,
      gradient: const [Color(0xFFEAB308), Color(0xFFCA8A04)],
      steps: [
        'Planning of HT & LT lines with MSEDCL approval',
        'Laying of underground cables / overhead poles',
        'Installation of transformers & feeder pillars',
        'Street light poles with LED fixtures',
        'Connection & testing',
      ],
      duration: '20-35 days',
      quality: 'MSEDCL Approved',
    ),
    ProcessItem(
      title: 'Water Line Work',
      icon: Icons.water,
      gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
      steps: [
        'Pipeline design as per layout size',
        'Excavation & trench preparation',
        'Laying DI/CI/PVC pipes (ISI mark only)',
        'Valve chambers & connection points',
        'Testing under pressure',
        'Backfilling & restoration',
      ],
      duration: '12-25 days',
      quality: 'ISI Certified',
    ),
    ProcessItem(
      title: 'Children Play Area & Walking Path',
      icon: Icons.park,
      gradient: const [Color(0xFFFCD34D), Color(0xFFEAB308)],
      steps: [
        'Excavation & leveling of ground',
        'RCC base for play equipment',
        'Installation of swings, slides, see-saws (ISI approved)',
        'Rubberized flooring / sand flooring for safety',
        'Jogging/walking track with paver blocks',
        'Plantation & seating benches',
      ],
      duration: '15-30 days',
      quality: 'ISI Approved',
    ),
    ProcessItem(
      title: 'STP Installation',
      icon: Icons.recycling,
      gradient: const [Color(0xFFFBBF24), Color(0xFFF97316)],
      steps: [
        'Design as per layout population load',
        'Excavation & base preparation',
        'RCC tank construction',
        'Aeration equipment & pumps installation',
        'Plumbing & pipe fittings',
        'Trial run & certification by Pollution Control Board',
      ],
      duration: '30-45 days',
      quality: 'PCB Certified',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      processes.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 700 + (index * 60)),
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.4),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D), Color(0xFF1E1E1E)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1200
                    ? 3
                    : constraints.maxWidth > 768
                    ? 2
                    : 1;

                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: List.generate(processes.length, (index) {
                    return SizedBox(
                      width:
                          (constraints.maxWidth - (24 * (crossAxisCount - 1))) /
                          crossAxisCount,
                      child: FadeTransition(
                        opacity: _fadeAnimations[index],
                        child: SlideTransition(
                          position: _slideAnimations[index],
                          child: ProcessCard(
                            process: processes[index],
                            index: index,
                            isExpanded: _expandedIndex == index,
                            onTap: () {
                              setState(() {
                                _expandedIndex = _expandedIndex == index
                                    ? null
                                    : index;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFCD34D), Color(0xFFF59E0B)],
          ).createShader(bounds),
          child: const Text(
            'How We Work',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 5,
          width: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFFFBBF24),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFBBF24).withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const SizedBox(height: 24),
        const Text(
          'Detailed step-by-step processes ensuring quality\nand timely project completion',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Color(0xFFD1D5DB), height: 1.6),
        ),
      ],
    );
  }
}

class ProcessCard extends StatefulWidget {
  final ProcessItem process;
  final int index;
  final bool isExpanded;
  final VoidCallback onTap;

  const ProcessCard({
    super.key,
    required this.process,
    required this.index,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<ProcessCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index * 200)),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
    super.dispose();
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
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _pulseController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.process.gradient[0].withOpacity(
                        0.3 * _glowAnimation.value,
                      ),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.process.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildStepsList(),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.process.gradient),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.process.gradient[0].withOpacity(0.5),
                  blurRadius: _isHovered ? 20 : 12,
                  spreadRadius: _isHovered ? 3 : 1,
                ),
              ],
            ),
            child: Transform.rotate(
              angle: _isHovered ? 0.1 : 0,
              child: Icon(widget.process.icon, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: _isHovered
                        ? widget.process.gradient
                        : [Colors.white, Colors.white],
                  ).createShader(bounds),
                  child: Text(
                    widget.process.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.schedule,
                      widget.process.duration,
                      widget.process.gradient[0],
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.verified,
                      widget.process.quality,
                      widget.process.gradient[1],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedRotation(
            turns: widget.isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.process.gradient[0].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.process.gradient[0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      child: widget.isExpanded
          ? Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: List.generate(
                  widget.process.steps.length,
                  (index) => _buildStepItem(index),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildStepItem(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: widget.isExpanded ? 1.0 : 0.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.process.gradient,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.process.gradient[0].withOpacity(
                                  0.4,
                                ),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.process.gradient[0].withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        widget.process.steps[index],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE5E7EB),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            widget.process.gradient[0].withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(21),
          bottomRight: Radius.circular(21),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.process.steps.length} Steps',
            style: TextStyle(
              fontSize: 13,
              color: widget.process.gradient[0],
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.isExpanded ? 'Tap to collapse' : 'Tap to expand',
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}

class ProcessItem {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final List<String> steps;
  final String duration;
  final String quality;

  ProcessItem({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.steps,
    required this.duration,
    required this.quality,
  });
}
