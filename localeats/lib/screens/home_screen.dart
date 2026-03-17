import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../models/vendor_model.dart';
import 'vendor_profile_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'Pizza';

  final List<String> _categories = ['Pizza', 'Asian', 'Burger', 'Bengali', 'Dessert'];

  final List<Map<String, dynamic>> _vendors = [
    {
      'id': '1',
      'name': "Mama's Kitchen",
      'cuisine': 'Home Chef',
      'distance': 0.8,
      'priceFrom': 180,
      'priceTo': 350,
      'rating': 4.8,
      'emoji': '🏠',
      'color': Color(0xFFFFF3CD),
    },
    {
      'id': '2',
      'name': 'Dhaka Deli',
      'cuisine': 'Bengali Cuisine',
      'distance': 1.2,
      'priceFrom': 120,
      'priceTo': 280,
      'rating': 4.6,
      'emoji': '🍛',
      'color': Color(0xFFE8F5E9),
    },
    {
      'id': '3',
      'name': 'Burger Express',
      'cuisine': 'Fast Food',
      'distance': 0.5,
      'priceFrom': 150,
      'priceTo': 320,
      'rating': 4.5,
      'emoji': '🍔',
      'color': Color(0xFFFCE4EC),
    },
    {
      'id': '4',
      'name': 'Asian Garden',
      'cuisine': 'Chinese • Thai',
      'distance': 1.8,
      'priceFrom': 200,
      'priceTo': 450,
      'rating': 4.7,
      'emoji': '🍜',
      'color': Color(0xFFE3F2FD),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategories(),
              _buildNearbyVendors(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivering to',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGray,
                  )),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 4),
                  Text('Bogura, BD',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                ],
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: AppColors.secondary,
            radius: 22,
            child: Text(
              'SF',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What would you like to eat\ntoday? 🍽️',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                height: 1.3,
              )),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search restaurants, food...',
                hintStyle: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontSize: 16,
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text('See All →',
                    style: GoogleFonts.poppins(
                      color: AppColors.secondary,
                      fontSize: 13,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final selected = _categories[i] == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = _categories[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
                    ),
                    child: Text(
                      _categories[i],
                      style: GoogleFonts.poppins(
                        color: selected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyVendors() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nearby Vendors',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontSize: 16,
                  )),
              Text('See All →',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 13,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ...(_vendors.map((v) => _VendorCard(
            vendor: v,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VendorProfileScreen(vendorData: v)),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 20)],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          } else if (i == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          } else {
            setState(() => _currentIndex = i);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGray,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final Map<String, dynamic> vendor;
  final VoidCallback onTap;

  const _VendorCard({required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: vendor['color'],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(vendor['emoji'], style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      )),
                  Text('${vendor['cuisine']} • ${vendor['distance']} km away',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGray,
                      )),
                  const SizedBox(height: 4),
                  Text('৳${vendor['priceFrom']} – ৳${vendor['priceTo']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 3),
                  Text('${vendor['rating']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
