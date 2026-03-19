import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});
  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  int _points = 150;
  final String _code = 'SHAHRIAR50';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Refer & Earn', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        elevation: 0, backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Points card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text('$_points', style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Reward Points', style: GoogleFonts.poppins(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Text('= ৳${(_points * 0.5).toStringAsFixed(0)} discount', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Referral code
            ScaleTransition(
              scale: _anim,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 15)],
                ),
                child: Column(
                  children: [
                    Text('Your Referral Code', style: GoogleFonts.poppins(color: AppColors.textGray)),
                    const SizedBox(height: 8),
                    Text(_code, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 3)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Code copied! 📋', style: GoogleFonts.poppins()), backgroundColor: AppColors.primary),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.copy, color: AppColors.primary, size: 16),
                            const SizedBox(width: 6),
                            Text('Copy Code', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // How it works
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('কীভাবে কাজ করে?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _HowItWorksItem('1', 'বন্ধুকে তোমার code শেয়ার করো', '📤'),
                  _HowItWorksItem('2', 'বন্ধু প্রথম order দিলে', '🛒'),
                  _HowItWorksItem('3', 'তুমি পাবে 50 points', '🪙'),
                  _HowItWorksItem('4', 'বন্ধু পাবে ৳50 discount', '💰'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Share feature coming soon! 🚀', style: GoogleFonts.poppins()), backgroundColor: AppColors.primary),
                  );
                },
                icon: const Icon(Icons.share),
                label: Text('Share with Friends', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksItem extends StatelessWidget {
  final String step, text, emoji;
  const _HowItWorksItem(this.step, this.text, this.emoji);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Center(child: Text(step, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13))),
          Text(emoji, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
