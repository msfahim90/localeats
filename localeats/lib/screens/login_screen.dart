import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _login() {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক email ও password দাও!')),
      );
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _socialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider দিয়ে login হচ্ছে...'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text('👋', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text('Welcome Back!', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Sign in to LocalEats', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Google button
              _SocialButton(
                color: Colors.white,
                borderColor: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Center(
                        child: Text('G', style: GoogleFonts.poppins(
                          color: const Color(0xFFDB4437),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Continue with Google', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  ],
                ),
                onTap: () => _socialLogin('Google'),
              ),
              const SizedBox(height: 12),
              // Facebook button
              _SocialButton(
                color: const Color(0xFF1877F2),
                borderColor: const Color(0xFF1877F2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Center(
                        child: Text('f', style: GoogleFonts.poppins(
                          color: const Color(0xFF1877F2),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Continue with Facebook', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white)),
                  ],
                ),
                onTap: () => _socialLogin('Facebook'),
              ),
              const SizedBox(height: 20),
              // Divider
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: GoogleFonts.poppins(color: AppColors.textGray)),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 20),
              // Email field
              _buildField(_emailCtrl, 'Email address', Icons.email_outlined),
              const SizedBox(height: 12),
              _buildField(_passCtrl, 'Password', Icons.lock_outline, obscure: true),
              const SizedBox(height: 24),
              // Sign in button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Sign In →', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: GoogleFonts.poppins(color: AppColors.textGray)),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: Text('Register Free', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: AppColors.textGray),
          prefixIcon: Icon(icon, color: AppColors.textGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;
  const _SocialButton({required this.child, required this.color, required this.borderColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
        ),
        child: child,
      ),
    );
  }
}
