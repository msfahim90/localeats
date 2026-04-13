import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'admin_panel_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _showSnack('Please enter email and password', Colors.red);
      return;
    }
    final auth = context.read<AuthService>();
    final error = await auth.signInWithEmail(
      _emailCtrl.text.trim(), _passCtrl.text);
    if (mounted) {
      if (error == null) {
        _navigateByRole(auth.role);
      } else {
        _showSnack(error, Colors.red);
      }
    }
  }

  void _navigateByRole(UserRole role) {
    Widget screen;
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
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => screen), (_) => false);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.poppins()),
          backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
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
                    Text('Welcome Back!', style: GoogleFonts.poppins(
                        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Sign in to LocalEats', style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildField(_emailCtrl, 'Email address', Icons.email_outlined,
                  type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _buildField(_passCtrl, 'Password', Icons.lock_outline,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textGray),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPassword(),
                  child: Text('Forgot Password?',
                      style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In →', style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",
                      style: GoogleFonts.poppins(color: AppColors.textGray)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: Text('Register Free',
                        style: GoogleFonts.poppins(
                            color: AppColors.primary, fontWeight: FontWeight.w600)),
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

  void _showForgotPassword() {
    final emailCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reset Password', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your email to receive a password reset link.',
                style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray)),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email address',
                hintStyle: GoogleFonts.poppins(color: AppColors.textGray),
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailCtrl.text.isEmpty) return;
              Navigator.pop(context);
              final auth = context.read<AuthService>();
              await auth.resetPassword(emailCtrl.text.trim());
              if (mounted) {
                _showSnack('Password reset email sent!', AppColors.primary);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Send', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon,
      {bool obscure = false, Widget? suffix, TextInputType? type}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: AppColors.textGray),
          prefixIcon: Icon(icon, color: AppColors.textGray),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
