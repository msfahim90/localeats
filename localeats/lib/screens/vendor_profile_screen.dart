import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class VendorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> vendorData;
  const VendorProfileScreen({super.key, required this.vendorData});

  final List<Map<String, dynamic>> _menu = const [
    {'id': 'm1', 'name': 'Chicken Biryani', 'desc': 'Fragrant rice with tender chicken', 'price': 220, 'emoji': '🍚'},
    {'id': 'm2', 'name': 'Dal Makhani', 'desc': 'Slow-cooked lentils, butter', 'price': 150, 'emoji': '🫘'},
    {'id': 'm3', 'name': 'Paratha Set', 'desc': '3 parathas with curry', 'price': 120, 'emoji': '🫓'},
    {'id': 'm4', 'name': 'Beef Kacchi', 'desc': 'Traditional Dhaka style', 'price': 280, 'emoji': '🥩'},
    {'id': 'm5', 'name': 'Mishti Doi', 'desc': 'Sweet yogurt dessert', 'price': 60, 'emoji': '🍮'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(vendorData['emoji'] ?? '🏠',
                          style: const TextStyle(fontSize: 60)),
                      Text(vendorData['name'] ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${vendorData['rating']} • ${vendorData['reviewCount'] ?? 127} reviews • ${vendorData['cuisine']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats row
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(value: '15-25', label: 'min delivery'),
                      _StatItem(value: '10%', label: 'commission'),
                      _StatItem(value: '৳40', label: 'delivery fee'),
                    ],
                  ),
                ),
                // Menu header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Menu',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Text('${_menu.length} items',
                          style: GoogleFonts.poppins(
                            color: AppColors.secondary,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _MenuItemCard(
                item: _menu[i],
                vendorId: vendorData['id'] ?? '1',
              ),
              childCount: _menu.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: Consumer<CartService>(
        builder: (_, cart, __) => cart.itemCount > 0
            ? FloatingActionButton.extended(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const CartScreen())),
                backgroundColor: AppColors.primary,
                label: Text('View Cart (${cart.itemCount})',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textDark,
            )),
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textGray,
            )),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String vendorId;
  const _MenuItemCard({required this.item, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(item['emoji'], style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text(item['desc'],
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textGray)),
                Text('৳${item['price']}',
                    style: GoogleFonts.poppins(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<CartService>().addItem(
                CartItem(
                  id: item['id'],
                  name: item['name'],
                  price: (item['price'] as num).toDouble(),
                  imageUrl: item['emoji'],
                ),
                vendorId,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['name']} added to cart!',
                      style: GoogleFonts.poppins()),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
