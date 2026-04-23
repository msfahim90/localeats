import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'location_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String _verificationId = '';
  bool _otpSent = false;
  bool _loading = false;
  String _selectedCountry = '+880';

  final List<Map<String, String>> _countries = [
    {'code': '+880', 'name': '🇧🇩 Bangladesh'},
    {'code': '+91', 'name': '🇮🇳 India'},
    {'code': '+1', 'name': '🇺🇸 USA'},
    {'code': '+44', 'name': '🇬🇧 UK'},
  ];

  Future<void> _sendOTP() async {
    if (_phoneCtrl.text.isEmpty || _phoneCtrl.text.length < 10) {
      _showSnack('Please enter a valid phone number', Colors.red);
      return;
    }
    setState(() => _loading = true);
    final phone = '$_selectedCountry${_phoneCtrl.text.trim()}';
    final auth = context.read<AuthService>();
    final error = await auth.sendOTP(phone, (verificationId) {
      setState(() {
        _verificationId = verificationId;
        _otpSent = true;
        _loading = false;
      });
    });
    if (error != null && mounted) {
      setState(() => _loading = false);
      _showSnack(error, Colors.red);
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpCtrl.text.isEmpty || _otpCtrl.text.length < 6) {
      _showSnack('Please enter the 6-digit OTP', Colors.red);
      return;
    }
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final phone = '$_selectedCountry${_phoneCtrl.text.trim()}';
    final error = await auth.verifyOTP(
        _verificationId, _otpCtrl.text.trim(), phone);
    if (mounted) {
      setState(() => _loading = false);
      if (error == null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const LocationScreen()),
                (_) => false);
      } else {
        _showSnack(error, Colors.red);
      }
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.poppins()),
          backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Phone Login',
            style: GoogleFonts.poppins(color: Colors.black,
                fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_outlined,
                      color: AppColors.primary, size: 40),
                ),
              ),
              const SizedBox(height: 24),
              Text(!_otpSent ? 'Enter your phone number'
                  : 'Enter the OTP',
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(!_otpSent
                  ? 'We\'ll send you a verification code'
                  : 'Enter the 6-digit code sent to your phone',
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade600, fontSize: 14)),
              const SizedBox(height: 32),

              if (!_otpSent) ...[
                // Country code + phone
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCountry,
                        underline: const SizedBox(),
                        items: _countries.map((c) =>
                            DropdownMenuItem(
                              value: c['code'],
                              child: Text('${c['name']} (${c['code']})',
                                  style: GoogleFonts.poppins(fontSize: 13)),
                            )).toList(),
                        onChanged: (v) =>
                            setState(() => _selectedCountry = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '01XXXXXXXXX',
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // OTP input
                TextField(
                  controller: _otpCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 24, letterSpacing: 8,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: '------',
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade300,
                        fontSize: 24, letterSpacing: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() {
                      _otpSent = false;
                      _otpCtrl.clear();
                    }),
                    child: Text('Change phone number',
                        style: GoogleFonts.poppins(
                            color: AppColors.primary)),
                  ),
                ),
              ],

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null
                      : (!_otpSent ? _sendOTP : _verifyOTP),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(!_otpSent ? 'Send OTP' : 'Verify OTP',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
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
