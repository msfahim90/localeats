import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../utils/app_colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _riderController;
  late AnimationController _pulseController;
  late AnimationController _stepController;
  late Animation<double> _riderAnim;
  late Animation<double> _pulseAnim;

  int _etaSeconds = 720; // 12 minutes
  Timer? _etaTimer;
  int _currentStep = 2; // On the Way

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Order Placed', 'time': '2:30 PM', 'sub': 'Confirmed', 'icon': Icons.check_circle},
    {'label': 'Being Prepared', 'time': '2:35 PM', 'sub': 'In kitchen', 'icon': Icons.restaurant},
    {'label': 'On the Way', 'time': '2:48 PM', 'sub': '1 km route', 'icon': Icons.delivery_dining},
    {'label': 'Delivered', 'time': '~3:00 PM', 'sub': 'Expected', 'icon': Icons.home},
  ];

  @override
  void initState() {
    super.initState();

    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _riderAnim = Tween<double>(begin: 0.08, end: 0.72).animate(
      CurvedAnimation(parent: _riderController, curve: Curves.easeInOut),
    );

    _pulseAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ETA countdown timer
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_etaSeconds > 0) {
        setState(() => _etaSeconds--);
        // Auto advance steps
        if (_etaSeconds == 480) setState(() => _currentStep = 2);
        if (_etaSeconds == 0) setState(() => _currentStep = 3);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _riderController.dispose();
    _pulseController.dispose();
    _stepController.dispose();
    _etaTimer?.cancel();
    super.dispose();
  }

  String get _etaText {
    final mins = _etaSeconds ~/ 60;
    final secs = _etaSeconds % 60;
    if (mins > 0) return '$mins min ${secs}s';
    return '${secs}s';
  }

  String get _etaLabel {
    if (_etaSeconds > 0) return 'Arriving in $_etaText';
    return '🎉 Delivered!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.secondary,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Tracking 🛵',
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Order #LE-20240235-4821',
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ETA Banner with countdown
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _etaSeconds > 0 ? _pulseAnim.value * 0.05 + 0.95 : 1.0,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(_etaLabel,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Map area
                  Container(
                    margin: const EdgeInsets.all(16),
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade200),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        // Grid
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomPaint(
                            size: const Size(double.infinity, 180),
                            painter: _GridPainter(),
                          ),
                        ),
                        // Route line
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Animated rider
                        AnimatedBuilder(
                          animation: _riderAnim,
                          builder: (_, __) {
                            return Positioned(
                              left: (MediaQuery.of(context).size.width - 32) * _riderAnim.value - 20,
                              top: 65,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [BoxShadow(color: AppColors.secondary.withOpacity(0.4), blurRadius: 8)],
                                    ),
                                    child: const Text('🛵', style: TextStyle(fontSize: 22)),
                                  ),
                                  // Shadow
                                  Container(
                                    width: 30, height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // Start marker
                        Positioned(
                          left: 16, top: 62,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
                            ),
                            child: const Text('🍽️', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        // End marker
                        Positioned(
                          right: 16, top: 62,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
                            ),
                            child: const Text('🏠', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        // Distance badge
                        Positioned(
                          bottom: 12, left: 0, right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('1.0 km • Bogura, BD',
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress Steps
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                    ),
                    child: Column(
                      children: List.generate(_steps.length, (i) {
                        final done = i < _currentStep;
                        final active = i == _currentStep - 1;
                        return _StepItem(
                          step: _steps[i],
                          done: done,
                          active: active,
                          isLast: i == _steps.length - 1,
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rider info
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54, height: 54,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('R', style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rahim • Your Rider',
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  Text(' 4.9 • Honda CB125',
                                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
                                ],
                              ),
                              Text('On the way to you 🛵',
                                  style: GoogleFonts.poppins(fontSize: 11, color: AppColors.primary)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.message_outlined, color: AppColors.primary, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 44, height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order summary
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        _SummaryRow('Chicken Biryani × 2', '৳440'),
                        _SummaryRow('Paratha Set × 1', '৳120'),
                        _SummaryRow('Delivery Fee', '৳40'),
                        _SummaryRow('Discount (10%)', '-৳56'),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            Text('৳544', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool done;
  final bool active;
  final bool isLast;
  const _StepItem({required this.step, required this.done, required this.active, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: done ? AppColors.primary : active ? AppColors.secondary : Colors.grey.shade200,
                shape: BoxShape.circle,
                boxShadow: done || active ? [BoxShadow(color: (done ? AppColors.primary : AppColors.secondary).withOpacity(0.3), blurRadius: 8)] : [],
              ),
              child: Icon(
                done ? Icons.check : step['icon'],
                color: done || active ? Colors.white : Colors.grey,
                size: 16,
              ),
            ),
            if (!isLast)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 2, height: 44,
                color: done ? AppColors.primary : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step['label'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: done ? AppColors.textDark : active ? AppColors.secondary : AppColors.textGray,
                      fontSize: 14,
                    )),
                Text('${step['time']} — ${step['sub']}',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
        ),
        if (done)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray)),
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.shade100..strokeWidth = 0.8;
    for (double i = 0; i < size.width; i += 28) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 28) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}
