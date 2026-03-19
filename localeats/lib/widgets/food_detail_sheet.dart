import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class FoodDetailSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  final String vendorId;
  const FoodDetailSheet({super.key, required this.item, required this.vendorId});
  @override
  State<FoodDetailSheet> createState() => _FoodDetailSheetState();
}

class _FoodDetailSheetState extends State<FoodDetailSheet> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: AppColors.lightOrange, borderRadius: BorderRadius.circular(20)),
            child: Center(child: Text(widget.item['emoji'], style: const TextStyle(fontSize: 52))),
          ),
          const SizedBox(height: 16),
          Text(widget.item['name'], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(widget.item['desc'] ?? 'Delicious food item', style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: ['Fresh', 'Halal', 'Homemade'].map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(20)),
              child: Text(tag, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NutritionItem(value: '350', label: 'Calories'),
                _NutritionItem(value: '22g', label: 'Protein'),
                _NutritionItem(value: '45g', label: 'Carbs'),
                _NutritionItem(value: '12g', label: 'Fat'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.remove, size: 18), onPressed: () { if (_qty > 1) setState(() => _qty--); }),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$_qty', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16))),
                    IconButton(icon: const Icon(Icons.add, size: 18), onPressed: () => setState(() => _qty++)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$_qty × ${widget.item['name']} cart এ যোগ হয়েছে! 🛒', style: GoogleFonts.poppins()),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Add ৳${((widget.item['price'] as num) * _qty).toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String value;
  final String label;
  const _NutritionItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
      ],
    );
  }
}
