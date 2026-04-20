import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import 'vendor_profile_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'see_all_vendors_screen.dart';
import 'filter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Pizza', 'Asian', 'Burger', 'Bengali', 'Dessert'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(auth),
                    _buildSearchBar(),
                    _buildCategories(),
                    _buildNearbyVendors(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(AuthService auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('🥗', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivering to', style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textGray)),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.secondary, size: 16),
                      const SizedBox(width: 2),
                      Text('Bogura, BD', style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: AppColors.secondary,
            radius: 22,
            child: Text(
              auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
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
                  fontSize: 22, fontWeight: FontWeight.bold,
                  color: AppColors.textDark, height: 1.3)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search restaurants, food...',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textGray, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textGray),
                              onPressed: () => setState(() => _searchQuery = ''))
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FilterScreen())),
                child: Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 22),
                ),
              ),
            ],
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
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories', style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 16)),
                Text('See All →', style: GoogleFonts.poppins(
                    color: AppColors.secondary, fontSize: 13)),
              ],
            ),
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
                    child: Text(_categories[i], style: GoogleFonts.poppins(
                        color: selected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w500, fontSize: 13)),
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
              Text('Nearby Vendors', style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 16)),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SeeAllVendorsScreen())),
                child: Text('See All →', style: GoogleFonts.poppins(
                    color: AppColors.secondary, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('vendors')
                .where('isApproved', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(
                    color: AppColors.primary));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Text('😕', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text('No vendors available yet',
                          style: GoogleFonts.poppins(color: AppColors.textGray)),
                    ],
                  ),
                );
              }

              var vendors = snapshot.data!.docs
                  .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
                  .where((v) {
                final matchCat = _selectedCategory == 'All' ||
                    v['category'] == _selectedCategory;
                final matchSearch = _searchQuery.isEmpty ||
                    v['name'].toString().toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    v['cuisine'].toString().toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                return matchCat && matchSearch;
              }).toList();

              if (vendors.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Text('😕', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No vendors found',
                            style: GoogleFonts.poppins(color: AppColors.textGray)),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: vendors.map((v) => _VendorCard(
                  vendor: v,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) =>
                          VendorProfileScreen(vendorData: v))),
                )).toList(),
              );
            },
          ),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen()));
          } else if (i == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()));
          } else {
            setState(() => _currentIndex = i);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGray,
        selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person), label: 'Profile'),
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
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Text(
                  vendor['emoji'] ?? '🍽️',
                  style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor['name'] ?? '',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  Text('${vendor['cuisine'] ?? ''} • ${vendor['distance'] ?? 0} km away',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textGray)),
                  const SizedBox(height: 4),
                  Text('৳${vendor['priceFrom'] ?? 0} – ৳${vendor['priceTo'] ?? 0}',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 3),
                  Text('${vendor['rating'] ?? 0}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
