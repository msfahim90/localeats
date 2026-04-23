import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'admin_panel_screen.dart';
import 'register_screen.dart';
import 'email_login_screen.dart';
import 'phone_login_screen.dart';
import 'location_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _navigateAfterLogin(BuildContext context, UserRole role,
      bool isNewUser) {
    Widget screen;
    if (isNewUser) {
      screen = const LocationScreen();
    } else {
      switch (role) {
        case UserRole.admin:
          screen = const AdminPanelScreen();
          break;
        case UserRole.vendor:
          screen = const VendorDashboardScreen();
          break;
        default:
          screen = const HomeScreen();
      }
    }
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => screen), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text('Sign up or Log in',
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Text('Select your preferred method to continue',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 48),

              // Google
              _AuthButton(
                onTap: auth.isLoading ? null : () async {
                  final error = await auth.signInWithGoogle();
                  if (context.mounted) {
                    if (error == null) {
                      _navigateAfterLogin(context, auth.role, false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error,
                            style: GoogleFonts.poppins()),
                            backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                color: Colors.white,
                borderColor: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Center(
                        child: Text('G', style: GoogleFonts.poppins(
                            color: const Color(0xFFDB4437),
                            fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Continue with Google',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Facebook
              _AuthButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Facebook login coming soon!',
                          style: GoogleFonts.poppins()),
                      backgroundColor: const Color(0xFF1877F2),
                    ),
                  );
                },
                color: const Color(0xFF1877F2),
                borderColor: const Color(0xFF1877F2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Text('f', style: GoogleFonts.poppins(
                            color: const Color(0xFF1877F2),
                            fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Continue with Facebook',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Email
              _AuthButton(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const EmailLoginScreen())),
                color: const Color(0xFFE91E8C),
                borderColor: const Color(0xFFE91E8C),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email_outlined,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Text('Email',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Phone
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const PhoneLoginScreen())),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_outlined,
                          size: 22, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text('Phone number',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              if (auth.isLoading)
                const Center(child: CircularProgressIndicator(
                    color: AppColors.primary)),

              const SizedBox(height: 16),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(text: 'Terms and Conditions',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.black87)),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                              color: Colors.black87)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;
  const _AuthButton({required this.child, required this.color,
      required this.borderColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: child,
      ),
    );
  }
}
