import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(50, 500);
  double _maxDistance = 5;
  List<String> _selectedCuisines = [];
  List<String> _selectedDietary = [];
  int _minRating = 0;

  final List<String> _cuisines = ['Bengali', 'Pizza', 'Burger', 'Asian', 'Dessert', 'BBQ'];
  final List<String> _dietary = ['Vegetarian', 'Halal', 'Spicy', 'Non-spicy', 'Vegan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Text('Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _priceRange = const RangeValues(50, 500);
              _maxDistance = 5;
              _selectedCuisines = [];
              _selectedDietary = [];
              _minRating = 0;
            }),
            child: Text('Reset', style: GoogleFonts.poppins(color: AppColors.secondary)),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Price range
          _SectionTitle('Price Range'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('৳${_priceRange.start.toInt()}', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
              Text('৳${_priceRange.end.toInt()}', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 50, max: 500,
            divisions: 45,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          const SizedBox(height: 20),
          // Distance
          _SectionTitle('Maximum Distance'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 km', style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 12)),
              Text('${_maxDistance.toStringAsFixed(1)} km', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          Slider(
            value: _maxDistance,
            min: 0.5, max: 10,
            divisions: 19,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _maxDistance = v),
          ),
          const SizedBox(height: 20),
          // Min rating
          _SectionTitle('Minimum Rating'),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (i) => GestureDetector(
              onTap: () => setState(() => _minRating = i + 1),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  i < _minRating ? Icons.star : Icons.star_border,
                  color: Colors.amber, size: 32,
                ),
              ),
            )),
          ),
          const SizedBox(height: 20),
          // Cuisine type
          _SectionTitle('Cuisine Type'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _cuisines.map((c) {
              final selected = _selectedCuisines.contains(c);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedCuisines.remove(c) : _selectedCuisines.add(c);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                  ),
                  child: Text(c, style: GoogleFonts.poppins(
                    color: selected ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.w500, fontSize: 13,
                  )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Dietary
          _SectionTitle('Dietary Preference'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _dietary.map((d) {
              final selected = _selectedDietary.contains(d);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedDietary.remove(d) : _selectedDietary.add(d);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.secondary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? AppColors.secondary : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                  ),
                  child: Text(d, style: GoogleFonts.poppins(
                    color: selected ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.w500, fontSize: 13,
                  )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          // Apply button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Filter applied! ✅', style: GoogleFonts.poppins()),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Apply Filters', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark));
  }
}
