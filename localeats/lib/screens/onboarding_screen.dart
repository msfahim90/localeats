import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'emoji': '🥗',
      'title': 'Local Food\nAt Your Door',
      'subtitle': 'Bogura এর সেরা home chefs আর local restaurants থেকে খাবার order করো',
      'bg': Color(0xFF2E8B57),
      'accent': Color(0xFF4CAF82),
    },
    {
      'emoji': '🛵',
      'title': 'Fast & Reliable\nDelivery',
      'subtitle': 'মাত্র ১৫-২৫ মিনিটে তোমার দরজায় পৌঁছে যাবে তাজা গরম খাবার',
      'bg': Color(0xFFFF7F50),
      'accent': Color(0xFFFF9B6B),
    },
    {
      'emoji': '💚',
      'title': 'Support Local\nBusinesses',
      'subtitle': 'মাত্র ১০% commission — local vendors দের সাথে থাকো, community কে সাপোর্ট করো',
      'bg': Color(0xFF1565C0),
      'accent': Color(0xFF1E88E5),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _animController.reset();
              _animController.forward();
            },
            itemCount: _pages.length,
            itemBuilder: (_, i) {
              final page = _pages[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: page['bg'],
                child: SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          // Big emoji with circle
                          Container(
                            width: 180, height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(page['emoji'], style: const TextStyle(fontSize: 80)),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            page['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            page['subtitle'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.6,
                            ),
                          ),
                          const Spacer(),
                          // Dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_pages.length, (j) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: j == _currentPage ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: j == _currentPage ? Colors.white : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )),
                          ),
                          const SizedBox(height: 32),
                          // Next / Get Started button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: page['bg'],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: Text(
                                _currentPage == _pages.length - 1 ? 'Get Started 🚀' : 'Next →',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_currentPage < _pages.length - 1)
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                              child: Text('Skip', style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
