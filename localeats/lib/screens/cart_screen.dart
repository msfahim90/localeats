import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'order_tracking_screen.dart';
import 'order_success_screen.dart';
import 'payment_screen.dart';
import 'vendor_profile_screen.dart';

class CartScreen extends StatefulWidget {
  final Map<String, dynamic>? vendorData;
  final List<Map<String, dynamic>>? initialItems;
  const CartScreen({super.key, this.vendorData, this.initialItems});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponCtrl = TextEditingController();
  bool _couponApplied = false;
  double _discount = 0;
  late List<Map<String, dynamic>> _items;
  late Map<String, dynamic> _vendor;

  final List<Map<String, dynamic>> _vendors = [
    {'id': '1', 'name': "Mama's Kitchen", 'cuisine': 'Home Chef', 'distance': 0.8, 'rating': 4.8, 'emoji': '🏠', 'color': Color(0xFFFFF3CD)},
    {'id': '2', 'name': 'Dhaka Deli', 'cuisine': 'Bengali Cuisine', 'distance': 1.2, 'rating': 4.6, 'emoji': '🍛', 'color': Color(0xFFE8F5E9)},
    {'id': '3', 'name': 'Burger Express', 'cuisine': 'Fast Food', 'distance': 0.5, 'rating': 4.5, 'emoji': '🍔', 'color': Color(0xFFFCE4EC)},
    {'id': '4', 'name': 'Asian Garden', 'cuisine': 'Chinese • Thai', 'distance': 1.8, 'rating': 4.7, 'emoji': '🍜', 'color': Color(0xFFE3F2FD)},
  ];

  final Map<String, List<Map<String, dynamic>>> _vendorMenus = {
    '1': [
      {'id': 'm1', 'name': 'Chicken Biryani', 'price': 220.0, 'emoji': '🍚', 'qty': 2},
      {'id': 'm2', 'name': 'Paratha Set', 'price': 120.0, 'emoji': '🫓', 'qty': 1},
    ],
    '2': [
      {'id': 'm3', 'name': 'Dal Makhani', 'price': 150.0, 'emoji': '🫘', 'qty': 1},
      {'id': 'm4', 'name': 'Beef Kacchi', 'price': 280.0, 'emoji': '🥩', 'qty': 1},
    ],
    '3': [
      {'id': 'm5', 'name': 'Chicken Burger', 'price': 180.0, 'emoji': '🍔', 'qty': 1},
      {'id': 'm6', 'name': 'French Fries', 'price': 80.0, 'emoji': '🍟', 'qty': 2},
    ],
    '4': [
      {'id': 'm7', 'name': 'Fried Rice', 'price': 200.0, 'emoji': '🍜', 'qty': 1},
      {'id': 'm8', 'name': 'Spring Roll', 'price': 120.0, 'emoji': '��', 'qty': 2},
    ],
  };

  @override
  void initState() {
    super.initState();
    _vendor = widget.vendorData ?? _vendors[0];
    _items = List<Map<String, dynamic>>.from(
      widget.initialItems ?? _vendorMenus[_vendor['id']] ?? _vendorMenus['1']!
    ).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _changeVendor(Map<String, dynamic> newVendor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change vendor?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Cart will be cleared and ${newVendor['name']} items will be loaded.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _vendor = newVendor;
                _items = List<Map<String, dynamic>>.from(
                  _vendorMenus[newVendor['id']] ?? []
                ).map((e) => Map<String, dynamic>.from(e)).toList();
                _couponApplied = false;
                _discount = 0;
                _couponCtrl.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Yes, change', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  double get _subtotal => _items.fold(0, (sum, i) => sum + i['price'] * i['qty']);
  double get _deliveryFee => 40;
  double get _discountAmount => _subtotal * _discount;
  double get _total => _subtotal + _deliveryFee - _discountAmount;

  void _increaseQty(int index) => setState(() => _items[index]['qty']++);
  void _decreaseQty(int index) {
    if (_items[index]['qty'] > 1) {
      setState(() => _items[index]['qty']--);
    } else {
      setState(() => _items.removeAt(index));
    }
  }

  void _applyCoupon() {
    if (_couponCtrl.text.toUpperCase() == 'LOCALEATS10') {
      setState(() { _couponApplied = true; _discount = 0.10; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🎉 10% discount applied!', style: GoogleFonts.poppins()), backgroundColor: AppColors.primary),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Invalid coupon code', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text('Your Cart', style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            if (_items.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                child: Text('${_items.fold(0, (s, i) => s + (i['qty'] as int))} items',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Vendor selector
                Text('Vendor select করো', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _vendors.length,
                    itemBuilder: (_, i) {
                      final v = _vendors[i];
                      final selected = v['id'] == _vendor['id'];
                      return GestureDetector(
                        onTap: () => selected ? null : _changeVendor(v),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? AppColors.primary : Colors.grey.shade200,
                              width: selected ? 2 : 1,
                            ),
                            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(v['emoji'], style: const TextStyle(fontSize: 24)),
                              const SizedBox(height: 4),
                              Text(
                                v['name'].toString().split(' ')[0],
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Current vendor info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Text(_vendor['emoji'], style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_vendor['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary)),
                          Text('${_vendor['cuisine']} • ${_vendor['distance']} km away',
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(' ${_vendor['rating']}',
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Cart items
                if (_items.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          const Text('🛒', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text('Cart is empty!', style: GoogleFonts.poppins(color: AppColors.textGray, fontWeight: FontWeight.w600)),
                          Text('Add items from a vendor', style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(_items.length, (i) => _CartItemCard(
                    item: _items[i],
                    onIncrease: () => _increaseQty(i),
                    onDecrease: () => _decreaseQty(i),
                  )),
                const SizedBox(height: 16),
                // Coupon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coupon Code', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _couponApplied ? AppColors.primary : Colors.grey.shade200),
                              ),
                              child: TextField(
                                controller: _couponCtrl,
                                enabled: !_couponApplied,
                                decoration: InputDecoration(
                                  hintText: 'Try: LOCALEATS10',
                                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _couponApplied ? null : _applyCoupon,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: _couponApplied ? Colors.grey.shade300 : AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _couponApplied ? '✓ Applied' : 'Apply',
                                style: GoogleFonts.poppins(
                                  color: _couponApplied ? AppColors.textGray : Colors.white,
                                  fontWeight: FontWeight.w600, fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_couponApplied)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('🎉 LOCALEATS10 — 10% discount applied!',
                              style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _SummaryRow('Subtotal', '৳${_subtotal.toStringAsFixed(0)}'),
                      _SummaryRow('Delivery Fee', '৳${_deliveryFee.toStringAsFixed(0)}'),
                      if (_couponApplied)
                        _SummaryRow('Discount (10%)', '-৳${_discountAmount.toStringAsFixed(0)}', color: AppColors.primary),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('৳${_total.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(total: _total))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Place Order', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('৳${_total.toStringAsFixed(0)} →',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  const _CartItemCard({required this.item, required this.onIncrease, required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: AppColors.lightOrange, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(item['emoji'], style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('৳${(item['price'] as double).toStringAsFixed(0)} each',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onDecrease,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.remove, size: 16, color: AppColors.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('${item['qty']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              GestureDetector(
                onTap: onIncrease,
                child: Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _SummaryRow(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray)),
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: color ?? AppColors.textDark)),
        ],
      ),
    );
  }
}
