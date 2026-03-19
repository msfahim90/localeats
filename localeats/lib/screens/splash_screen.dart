import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeIn)));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.7, curve: Curves.elasticOut)));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1, curve: Curves.easeOut)));
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('onboarding_seen') ?? false;
      if (!seen) {
        await prefs.setBool('onboarding_seen', true);
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      } else {
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    } catch (_) {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  child: const Center(child: Text('🥗', style: TextStyle(fontSize: 52))),
                ),
              ),
              const SizedBox(height: 28),
              SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    Text('LocalEats',
                        style: GoogleFonts.poppins(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    Text('Fast, Reliable Food Delivery',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              SlideTransition(
                position: _slideAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => AnimatedContainer(
                    duration: Duration(milliseconds: 300 + i * 100),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == 0 ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.white : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
