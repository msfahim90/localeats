import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'admin_panel_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final auth = context.read<AuthService>();
    if (auth.isLoggedIn) {
      Widget screen;
      switch (auth.role) {
        case UserRole.admin:
          screen = const AdminPanelScreen();
          break;
        case UserRole.vendor:
          screen = const VendorDashboardScreen();
          break;
        default:
          screen = const HomeScreen();
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => screen));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10))],
                  ),
                  child: const Center(
                      child: Text('🥗', style: TextStyle(fontSize: 52))),
                ),
              ),
              const SizedBox(height: 28),
              Text('LocalEats',
                  style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5)),
              const SizedBox(height: 8),
              Text('Fast, Reliable Food Delivery',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85))),
            ],
          ),
        ),
      ),
    );
  }
}
