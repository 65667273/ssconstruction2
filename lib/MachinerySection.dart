import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ss/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class MachinerySection extends StatefulWidget {
  const MachinerySection({super.key});

  @override
  State<MachinerySection> createState() => _MachinerySectionState();
}

class _MachinerySectionState extends State<MachinerySection>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;

  final List<MachineItem> machines = [
    MachineItem(imagePath: 'images/jcb.jpg', name: 'JCB', quantity: '4 Units'),
    MachineItem(
      imagePath: 'images/chota_roller.jpg',
      name: 'Chota Rollar',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/motha_roller.jpg',
      name: 'Motha Rollar',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/ajax_machine.jpg',
      name: 'AJAX Machine',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/bullero.jpg',
      name: 'Bullero',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/hand_mixer.jpg',
      name: 'Hand Mixer Machines',
      quantity: '2 Units',
    ),
    MachineItem(
      imagePath: 'images/plate_compactor.jpg',
      name: 'Plate Compactor',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/skid_machine.jpg',
      name: 'Skid Machines for Road Making',
      quantity: '2 Units',
    ),
    MachineItem(
      imagePath: 'images/vibrator.jpg',
      name: 'Vibrators',
      quantity: '2 Units',
    ),
    MachineItem(
      imagePath: 'images/vibrator_needle.jpg',
      name: 'Vibrator Needles',
      quantity: '2 Units',
    ),
    MachineItem(
      imagePath: 'images/fan_floater.jpg',
      name: 'Fan Floater',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/road_cutting.png',
      name: 'Road Cutting Machine',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/road_channel.jpg',
      name: 'Road Channels',
      quantity: 'Multiple',
    ),
    MachineItem(
      imagePath: 'images/dewatering_5hp.jpg',
      name: 'Dewatering Machine (5 HP)',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/dewatering_2hp.jpg',
      name: 'Dewatering Machine (2 HP)',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/diesel_pump.jpg',
      name: 'Diesel Pump for Dewatering',
      quantity: '1 Unit',
    ),
    MachineItem(
      imagePath: 'images/dewatering_pump_2_5hp.jpg',
      name: 'Dewatering Pumps (2.5 HP)',
      quantity: '2 Units',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);

    // Trigger animation after mount
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _cardController.forward();
      }
    });
  }

  void _onScroll() {
    // Additional scroll-based animations can be added here
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp(String machineName) async {
    final phoneNumber = '+919823388866';
    final message = Uri.encodeComponent(
      'Hi, I would like to inquire about renting: $machineName',
    );
    final url = Uri.parse('https://wa.me/$phoneNumber?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Animated Background
            _buildAnimatedBackground(),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width > 600 ? 80 : 50,
                horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 15,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    children: [
                      // Header Section
                      _buildHeader(),
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 600
                            ? 50
                            : 30,
                      ),

                      // Machinery Grid
                      _buildMachineryGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: AnimatedBackgroundPainter(
              animationValue: _backgroundController.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AnimatedRevealWidget(
      visible: _isVisible,
      delay: 0,
      child: Column(
        children: [
          // Animated Title
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  const Color(0xFFFAAB0C),
                  Colors.yellow.shade600,
                  const Color(0xFFFAAB0C),
                ],
              ).createShader(bounds);
            },
            child: Text(
              'Machinery & Equipment',
              style: TextStyle(
                fontSize: isMobile ? 28 : 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 20),

          // Animated Subtitle
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 15 : 30,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color(0xFFFAAB0C), width: 2),
                bottom: BorderSide(color: const Color(0xFFFAAB0C), width: 2),
              ),
            ),
            child: Text(
              'Modern equipment for faster, safer, and high-quality work delivery',
              style: TextStyle(
                fontSize: isMobile ? 13 : 18,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineryGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount;
        double childAspectRatio;

        if (width > 1200) {
          crossAxisCount = 4;
          childAspectRatio = 0.8;
        } else if (width > 900) {
          crossAxisCount = 3;
          childAspectRatio = 0.8;
        } else if (width > 600) {
          crossAxisCount = 2;
          childAspectRatio = 0.85;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: width > 600 ? 20 : 12,
            mainAxisSpacing: width > 600 ? 20 : 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            return AnimatedRevealWidget(
              visible: _isVisible,
              delay: 100 + (index * 50),
              child: _MachineryCard(
                machine: machines[index],
                index: index,
                onEnquire: () => _launchWhatsApp(machines[index].name),
              ),
            );
          },
        );
      },
    );
  }
}

class _MachineryCard extends StatefulWidget {
  final MachineItem machine;
  final int index;
  final VoidCallback onEnquire;

  const _MachineryCard({
    required this.machine,
    required this.index,
    required this.onEnquire,
  });

  @override
  State<_MachineryCard> createState() => _MachineryCardState();
}

class _MachineryCardState extends State<_MachineryCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isButtonHovered = false;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.index % 3) * 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final float = isMobile ? 3 : 5 * sin(_floatController.value * 2 * pi);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Transform.translate(
            offset: Offset(0, 1.1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_isHovered ? -0.05 : 0)
                ..scale(_isHovered ? 1.02 : 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)]
                        : [const Color(0xFF0D0D0D), const Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovered
                        ? const Color(0xFFFAAB0C)
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFAAB0C).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Section
                      Expanded(
                        flex: isMobile ? 4 : 3,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF1A1A1A),
                                const Color(0xFF0D0D0D),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Main Image
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                                  child: Image.asset(
                                    widget.machine.imagePath,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFFFAAB0C,
                                            ).withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.construction,
                                            size: isMobile ? 40 : 60,
                                            color: const Color(0xFFFAAB0C),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Quantity Badge
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 8 : 12,
                                    vertical: isMobile ? 4 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAAB0C),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFAAB0C,
                                        ).withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.machine.quantity,
                                    style: TextStyle(
                                      fontSize: isMobile ? 10 : 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Content Section
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 12 : 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Machine Name
                              Text(
                                widget.machine.name,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: isMobile ? 8 : 12),

                              // Enquire Button
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isButtonHovered = true),
                                onExit: (_) =>
                                    setState(() => _isButtonHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()
                                    ..scale(_isButtonHovered ? 1.05 : 1.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: widget.onEnquire,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _isButtonHovered
                                            ? const Color(0xFFFAAB0C)
                                            : Colors.white.withOpacity(0.1),
                                        foregroundColor: _isButtonHovered
                                            ? Colors.black
                                            : const Color(0xFFFAAB0C),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 12 : 16,
                                          vertical: isMobile ? 10 : 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          side: BorderSide(
                                            color: const Color(0xFFFAAB0C),
                                            width: 2,
                                          ),
                                        ),
                                        elevation: _isButtonHovered ? 8 : 0,
                                        shadowColor: const Color(
                                          0xFFFAAB0C,
                                        ).withOpacity(0.5),
                                      ),
                                      icon: Icon(
                                        Icons.chat_bubble_outline,
                                        size: isMobile ? 16 : 18,
                                      ),
                                      label: Text(
                                        'Enquire Now',
                                        style: TextStyle(
                                          fontSize: isMobile ? 12 : 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
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
                    ],
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

// MachineItem class (update in your constant.dart file)
class MachineItem {
  final String imagePath;
  final String name;
  final String quantity;

  MachineItem({
    required this.imagePath,
    required this.name,
    required this.quantity,
  });
}
