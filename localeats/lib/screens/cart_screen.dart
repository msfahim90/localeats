import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/cart_service.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();
  bool _couponApplied = false;

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
        title: Consumer<CartService>(
          builder: (_, cart, __) => Row(
            children: [
              Text('Your Cart',
                  style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(width: 8),
              if (cart.itemCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${cart.itemCount} items',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
      body: Consumer<CartService>(
        builder: (_, cart, __) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                  Text('Add items from a vendor',
                      style: GoogleFonts.poppins(color: AppColors.textGray)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Cart items
                    ...cart.items.map((item) => _CartItemCard(item: item)),
                    const SizedBox(height: 16),
                    // Coupon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _couponCtrl,
                              decoration: InputDecoration(
                                hintText: 'Enter coupon code (LOCALEATS10)',
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 12, color: AppColors.textGray),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final success = cart.applyCoupon(_couponCtrl.text);
                              setState(() => _couponApplied = success);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(success
                                    ? '✅ LOCALEATS10 — 10% discount applied!'
                                    : '❌ Invalid coupon code'),
                                backgroundColor: success ? AppColors.primary : Colors.red,
                              ));
                            },
                            child: Text('Apply',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      ),
                    ),
                    if (_couponApplied || cart.appliedCoupon.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '🎉 ${cart.appliedCoupon} — 10% discount applied',
                          style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
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
                        children: [
                          _SummaryRow('Subtotal', '৳${cart.subtotal.toStringAsFixed(0)}'),
                          _SummaryRow('Delivery Fee', '৳${cart.deliveryFee.toStringAsFixed(0)}'),
                          if (cart.discountAmount > 0)
                            _SummaryRow('Discount (10%)',
                                '-৳${cart.discountAmount.toStringAsFixed(0)}',
                                valueColor: AppColors.primary),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('৳${cart.total.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textDark)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Place order button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.clearCart();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrderTrackingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Place Order  ৳${cart.total.toStringAsFixed(0)} →',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(item.imageUrl, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('৳${item.price.toStringAsFixed(0)} each',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          Row(
            children: [
              _QtyBtn(
                icon: Icons.remove,
                onTap: () => context.read<CartService>().removeItem(item.id),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${item.quantity}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
              _QtyBtn(
                icon: Icons.add,
                onTap: () => context.read<CartService>().addItem(
                  CartItem(id: item.id, name: item.name, price: item.price, imageUrl: item.imageUrl),
                  'current',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: valueColor ?? AppColors.textDark,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
