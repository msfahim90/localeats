import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'order_tracking_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final double total;
  const OrderSuccessScreen({super.key, required this.total});
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late AnimationController _slideController;
  late Animation<double> _checkAnim;
  late Animation<double> _slideAnim;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _confettiController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _checkAnim = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _slideAnim = CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic);

    for (int i = 0; i < 30; i++) {
      _particles.add(_ConfettiParticle(random: _random));
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      _checkController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (_, __) => CustomPaint(
              painter: _ConfettiPainter(_particles, _confettiController.value),
              size: MediaQuery.of(context).size,
            ),
          ),
          // Content
          SafeArea(
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
                  .animate(_slideAnim),
              child: FadeTransition(
                opacity: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success circle
                      ScaleTransition(
                        scale: _checkAnim,
                        child: Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 10),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 64),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('Order Placed! 🎉',
                          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text('তোমার খাবার তৈরি হচ্ছে!',
                          style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textGray)),
                      const SizedBox(height: 32),
                      // Order details card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 15)],
                        ),
                        child: Column(
                          children: [
                            _InfoRow('Order ID', '#LE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
                            const Divider(height: 20),
                            _InfoRow('Total Amount', '৳${widget.total.toStringAsFixed(0)}'),
                            const Divider(height: 20),
                            _InfoRow('Estimated Time', '15-25 minutes'),
                            const Divider(height: 20),
                            _InfoRow('Payment', 'Cash on Delivery'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Track order button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => const OrderTrackingScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.delivery_dining, size: 22),
                              const SizedBox(width: 8),
                              Text('Track Order', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Back to home
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('Back to Home', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ),
                      ),
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
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14)),
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
      ],
    );
  }
}

class _ConfettiParticle {
  late double x, y, speed, size, angle;
  late Color color;
  _ConfettiParticle({required Random random}) {
    x = random.nextDouble();
    y = random.nextDouble() * -1;
    speed = 0.2 + random.nextDouble() * 0.3;
    size = 6 + random.nextDouble() * 8;
    angle = random.nextDouble() * 2 * pi;
    color = [
      AppColors.primary, AppColors.secondary,
      Colors.amber, Colors.pink, Colors.blue,
    ][random.nextInt(5)];
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;
  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + progress * p.speed) % 1.2;
      final paint = Paint()..color = p.color.withOpacity(0.8);
      canvas.save();
      canvas.translate(p.x * size.width, y * size.height);
      canvas.rotate(p.angle + progress * 3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5), const Radius.circular(2)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
