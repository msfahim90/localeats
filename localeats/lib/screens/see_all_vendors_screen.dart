import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'vendor_profile_screen.dart';

class SeeAllVendorsScreen extends StatefulWidget {
  const SeeAllVendorsScreen({super.key});
  @override
  State<SeeAllVendorsScreen> createState() => _SeeAllVendorsScreenState();
}

class _SeeAllVendorsScreenState extends State<SeeAllVendorsScreen> {
  String _sortBy = 'Rating';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allVendors = [
    {'id': '1', 'name': "Mama's Kitchen", 'cuisine': 'Home Chef', 'category': 'Bengali', 'distance': 0.8, 'priceFrom': 180, 'priceTo': 350, 'rating': 4.8, 'reviews': 127, 'emoji': '🏠', 'color': Color(0xFFFFF3CD), 'isOpen': true},
    {'id': '2', 'name': 'Dhaka Deli', 'cuisine': 'Bengali Cuisine', 'category': 'Bengali', 'distance': 1.2, 'priceFrom': 120, 'priceTo': 280, 'rating': 4.6, 'reviews': 89, 'emoji': '🍛', 'color': Color(0xFFE8F5E9), 'isOpen': true},
    {'id': '3', 'name': 'Burger Express', 'cuisine': 'Fast Food', 'category': 'Burger', 'distance': 0.5, 'priceFrom': 150, 'priceTo': 320, 'rating': 4.5, 'reviews': 64, 'emoji': '🍔', 'color': Color(0xFFFCE4EC), 'isOpen': true},
    {'id': '4', 'name': 'Asian Garden', 'cuisine': 'Chinese • Thai', 'category': 'Asian', 'distance': 1.8, 'priceFrom': 200, 'priceTo': 450, 'rating': 4.7, 'reviews': 103, 'emoji': '🍜', 'color': Color(0xFFE3F2FD), 'isOpen': false},
    {'id': '5', 'name': 'Pizza Palace', 'cuisine': 'Italian', 'category': 'Pizza', 'distance': 1.0, 'priceFrom': 250, 'priceTo': 500, 'rating': 4.4, 'reviews': 52, 'emoji': '🍕', 'color': Color(0xFFFFF8E1), 'isOpen': true},
    {'id': '6', 'name': 'Sweet Corner', 'cuisine': 'Desserts', 'category': 'Dessert', 'distance': 0.7, 'priceFrom': 50, 'priceTo': 150, 'rating': 4.9, 'reviews': 201, 'emoji': '🍰', 'color': Color(0xFFF3E5F5), 'isOpen': true},
    {'id': '7', 'name': 'Noodle House', 'cuisine': 'Chinese', 'category': 'Asian', 'distance': 2.1, 'priceFrom': 130, 'priceTo': 300, 'rating': 4.3, 'reviews': 45, 'emoji': '🍝', 'color': Color(0xFFE8EAF6), 'isOpen': true},
    {'id': '8', 'name': 'Kebab Corner', 'cuisine': 'BBQ', 'category': 'Bengali', 'distance': 1.5, 'priceFrom': 180, 'priceTo': 400, 'rating': 4.6, 'reviews': 78, 'emoji': '🥙', 'color': Color(0xFFFBE9E7), 'isOpen': false},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _allVendors.where((v) {
      return _searchQuery.isEmpty ||
          v['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v['cuisine'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortBy == 'Rating') list.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    if (_sortBy == 'Distance') list.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    if (_sortBy == 'Price') list.sort((a, b) => (a['priceFrom'] as int).compareTo(b['priceFrom'] as int));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('All Vendors', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  hintStyle: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          // Sort options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: ['Rating', 'Distance', 'Price'].map((s) {
                final selected = _sortBy == s;
                return GestureDetector(
                  onTap: () => setState(() => _sortBy = s),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
                    ),
                    child: Text(s, style: GoogleFonts.poppins(
                      color: selected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w500, fontSize: 13,
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
          // Vendor list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final v = _filtered[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VendorProfileScreen(vendorData: v))),
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
                        Stack(
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(color: v['color'], borderRadius: BorderRadius.circular(14)),
                              child: Center(child: Text(v['emoji'], style: const TextStyle(fontSize: 30))),
                            ),
                            if (!v['isOpen'])
                              Container(
                                width: 64, height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(child: Text('Closed', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(v['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: v['isOpen'] ? AppColors.lightGreen : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      v['isOpen'] ? 'Open' : 'Closed',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: v['isOpen'] ? AppColors.primary : AppColors.textGray,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text('${v['cuisine']} • ${v['distance']} km',
                                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
                              const SizedBox(height: 4),
                              Text('৳${v['priceFrom']} – ৳${v['priceTo']}',
                                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 3),
                                  Text('${v['rating']}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('${v['reviews']} reviews', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
                          ],
                        ),
                      ],
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
}
