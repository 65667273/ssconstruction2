import 'dart:math';
import 'dart:ui';
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

  final List<ProcessItem> processes = [
    ProcessItem(
      title: 'Cement Road Construction',
      icon: Icons.construction,
      imageUrl:
          'https://fra.cloud.appwrite.io/v1/storage/buckets/69410e4f002f12a6a22b/files/6948f8a50029504b64bb/view?project=69410e2700329697a6d1&mode=admin',
      gradient: const [Color(0xFFFBBF24), Color(0xFFF97316)],
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
      imageUrl:
          'https://fra.cloud.appwrite.io/v1/storage/buckets/69410e4f002f12a6a22b/files/6948fa1a001abefa48c3/view?project=69410e2700329697a6d1&mode=admin',
      gradient: const [Color(0xFF60A5FA), Color(0xFF06B6D4)],
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
      imageUrl:
          'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800&q=80',
      gradient: const [Color(0xFFFACC15), Color(0xFFF59E0B)],
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
      imageUrl:
          'https://fra.cloud.appwrite.io/v1/storage/buckets/69410e4f002f12a6a22b/files/6948fa7a0003ceea30b8/view?project=69410e2700329697a6d1&mode=admin',
      gradient: const [Color(0xFF22D3EE), Color(0xFF3B82F6)],
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
      imageUrl:
          'https://fra.cloud.appwrite.io/v1/storage/buckets/69410e4f002f12a6a22b/files/6948fab50011ba19765d/view?project=69410e2700329697a6d1&mode=admin',
      gradient: const [Color(0xFF4ADE80), Color(0xFF10B981)],
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
      imageUrl:
          'https://fra.cloud.appwrite.io/v1/storage/buckets/69410e4f002f12a6a22b/files/6948fb07001cb1b7e673/view?project=69410e2700329697a6d1&mode=admin',
      gradient: const [Color(0xFF2DD4BF), Color(0xFF10B981)],
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
        duration: const Duration(milliseconds: 600),
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
        begin: const Offset(0, 0.3),
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

  void _showProcessModal(BuildContext context, ProcessItem process) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ProcessModalModern(process: process, animation: animation);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
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

              double itemWidth =
                  (constraints.maxWidth - (24 * (crossAxisCount - 1))) /
                  crossAxisCount;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: List.generate(processes.length, (index) {
                  return SizedBox(
                    width: itemWidth,
                    child: FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: SlideTransition(
                        position: _slideAnimations[index],
                        child: ProcessCard(
                          process: processes[index],
                          onTap: () =>
                              _showProcessModal(context, processes[index]),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
          ).createShader(bounds),
          child: const Text(
            'How We Work',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
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
        const SizedBox(height: 32),
        const Text(
          'Detailed step-by-step processes ensuring quality\nand timely project completion',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF), height: 1.6),
        ),
      ],
    );
  }
}

class ProcessCard extends StatefulWidget {
  final ProcessItem process;
  final VoidCallback onTap;

  const ProcessCard({super.key, required this.process, required this.onTap});

  @override
  State<ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<ProcessCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
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
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.process.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_buildImageSection(), _buildContentSection()],
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

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              widget.process.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: Icon(
                    widget.process.icon,
                    size: 64,
                    color: widget.process.gradient[0],
                  ),
                );
              },
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.process.gradient[0].withOpacity(0.6),
                  widget.process.gradient[1].withOpacity(0.4),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
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
              child: Icon(widget.process.icon, color: Colors.white, size: 28),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              '${widget.process.steps.length} Steps',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.process.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isHovered ? widget.process.gradient[0] : Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.schedule, widget.process.duration),
              _buildInfoChip(Icons.verified, widget.process.quality),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[800]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'View Process',
                  style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(
                    _isHovered ? 4 : 0,
                    0,
                    0,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: widget.process.gradient[0],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: widget.process.gradient[0]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[300],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ProcessModalModern extends StatefulWidget {
  final ProcessItem process;
  final Animation<double> animation;

  const ProcessModalModern({
    super.key,
    required this.process,
    required this.animation,
  });

  @override
  State<ProcessModalModern> createState() => _ProcessModalModernState();
}

class _ProcessModalModernState extends State<ProcessModalModern>
    with TickerProviderStateMixin {
  late List<AnimationController> _stepControllers;
  late ScrollController _scrollController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _stepControllers = List.generate(
      widget.process.steps.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500 + (index * 50)),
        vsync: this,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < _stepControllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 80), () {
          if (mounted) {
            _stepControllers[i].forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 950, maxHeight: 750),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: widget.process.gradient[0].withOpacity(0.3),
              blurRadius: 60,
              spreadRadius: 15,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1A1A1A).withOpacity(0.85),
                    const Color(0xFF2D2D2D).withOpacity(0.85),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  _buildModernHeader(context),
                  Expanded(child: _buildStepsListModern()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.process.gradient[0].withOpacity(0.8),
                  widget.process.gradient[1].withOpacity(0.6),
                  Colors.transparent,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.darken,
            child: Image.network(
              widget.process.imageUrl,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 260,
                  color: Colors.grey[800],
                  child: Icon(
                    widget.process.icon,
                    size: 100,
                    color: widget.process.gradient[0],
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF1A1A1A).withOpacity(0.9),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(28, 60, 28, 28),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.process.gradient,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: widget.process.gradient[0].withOpacity(0.6),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.process.icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.process.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildModernBadge(
                            Icons.schedule,
                            widget.process.duration,
                          ),
                          _buildModernBadge(
                            Icons.verified_user,
                            widget.process.quality,
                          ),
                          _buildModernBadge(
                            Icons.layers,
                            '${widget.process.steps.length} Steps',
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
      ],
    );
  }

  Widget _buildModernBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.process.gradient[0].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: widget.process.gradient[0]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[300],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsListModern() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      itemCount: widget.process.steps.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: widget.process.gradient,
                  ).createShader(bounds),
                  child: const Text(
                    'Process Steps',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: widget.process.gradient),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        }

        final stepIndex = index - 1;
        final isCompleted = _currentStep > stepIndex;
        final isCurrent = _currentStep == stepIndex;

        return AnimatedBuilder(
          animation: _stepControllers[stepIndex],
          builder: (context, child) {
            final value = _stepControllers[stepIndex].value;
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(-30 * (1 - value), 0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? widget.process.gradient[0].withOpacity(0.15)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCurrent
                          ? widget.process.gradient[0].withOpacity(0.6)
                          : widget.process.gradient[0].withOpacity(0.15),
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: widget.process.gradient[0].withOpacity(
                                0.2,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.process.gradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: widget.process.gradient[0].withOpacity(
                                isCompleted ? 0.5 : 0.3,
                              ),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 24)
                              : Text(
                                  '${stepIndex + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.process.steps[stepIndex],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[200],
                            height: 1.6,
                            fontWeight: isCurrent
                                ? FontWeight.w600
                                : FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: isCompleted
                            ? Icon(
                                Icons.check_circle,
                                color: widget.process.gradient[0],
                                size: 24,
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                color: widget.process.gradient[0].withOpacity(
                                  0.4,
                                ),
                                size: 16,
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
}

class ProcessItem {
  final String title;
  final IconData icon;
  final String imageUrl;
  final List<Color> gradient;
  final List<String> steps;
  final String duration;
  final String quality;

  ProcessItem({
    required this.title,
    required this.icon,
    required this.imageUrl,
    required this.gradient,
    required this.steps,
    required this.duration,
    required this.quality,
  });
}
