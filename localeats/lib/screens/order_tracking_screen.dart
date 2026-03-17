import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _riderAnim;

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Order Placed', 'time': '2:30 PM', 'sub': 'Confirmed', 'done': true},
    {'label': 'Being Prepared', 'time': '2:35 PM', 'sub': 'In kitchen', 'done': true},
    {'label': 'On the Way', 'time': '2:48 PM', 'sub': '1 km route', 'done': false},
    {'label': 'Delivered', 'time': '~3:00 PM', 'sub': 'Expected', 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _riderAnim = Tween<double>(begin: 0.1, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Tracking 🛵',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Order #LE-20240235-4821',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ETA Banner
            Container(
              color: AppColors.secondary,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text('Arriving in 12 minutes',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            // Map placeholder
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Stack(
                children: [
                  // Grid lines
                  CustomPaint(
                    size: const Size(double.infinity, 180),
                    painter: _GridPainter(),
                  ),
                  // Route animation
                  AnimatedBuilder(
                    animation: _riderAnim,
                    builder: (_, __) {
                      return Positioned(
                        left: MediaQuery.of(context).size.width * _riderAnim.value - 40,
                        top: 70,
                        child: const Text('🛵', style: TextStyle(fontSize: 28)),
                      );
                    },
                  ),
                  // Start/End markers
                  const Positioned(
                    left: 20, top: 65,
                    child: Text('🔑', style: TextStyle(fontSize: 24)),
                  ),
                  Positioned(
                    right: 20, top: 65,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🏠', style: TextStyle(fontSize: 24)),
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
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
              ),
              child: Column(
                children: List.generate(_steps.length, (i) => _StepItem(
                  step: _steps[i],
                  isLast: i == _steps.length - 1,
                )),
              ),
            ),
            const SizedBox(height: 16),
            // Rider info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.lightGreen,
                    child: Text('R', style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rahim • Your Rider',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            Text(' 4.9 • Honda CB125',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: AppColors.textGray)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final Map<String, dynamic> step;
  final bool isLast;
  const _StepItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final done = step['done'] as bool;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? AppColors.primary : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                done ? Icons.check : Icons.radio_button_unchecked,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: done ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step['label'],
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: done ? AppColors.textDark : AppColors.textGray)),
                Text('${step['time']} - ${step['sub']}',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade100
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
