import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  final String vendorName;
  const ReviewsScreen({super.key, required this.vendorName});
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _userRating = 0;
  final _reviewCtrl = TextEditingController();

  final List<Map<String, dynamic>> _reviews = [
    {'name': 'Anika T.', 'rating': 5, 'comment': 'Absolutely delicious! Best biryani in Bogura. Will order again!', 'time': '2 hours ago', 'avatar': 'A'},
    {'name': 'Rahim H.', 'rating': 4, 'comment': 'Great food, quick delivery. The paratha was perfect!', 'time': '1 day ago', 'avatar': 'R'},
    {'name': 'Sumaiya K.', 'rating': 5, 'comment': 'Mama\'s kitchen never disappoints. Authentic home-cooked taste!', 'time': '2 days ago', 'avatar': 'S'},
    {'name': 'Farhan M.', 'rating': 4, 'comment': 'Good portion size and tasty food. Delivery was on time.', 'time': '3 days ago', 'avatar': 'F'},
    {'name': 'Nusrat J.', 'rating': 5, 'comment': 'Love the dal makhani! Reminded me of home cooking.', 'time': '5 days ago', 'avatar': 'N'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Reviews & Ratings', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rating overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text('4.8', style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    Row(children: List.generate(5, (i) => Icon(Icons.star, color: Colors.amber, size: 18))),
                    const SizedBox(height: 4),
                    Text('127 reviews', style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _RatingBar(label: '5', value: 0.72, color: Colors.green),
                      _RatingBar(label: '4', value: 0.18, color: Colors.lightGreen),
                      _RatingBar(label: '3', value: 0.06, color: Colors.amber),
                      _RatingBar(label: '2', value: 0.03, color: Colors.orange),
                      _RatingBar(label: '1', value: 0.01, color: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Write review
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Write a Review', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _userRating = i + 1),
                    child: Icon(
                      i < _userRating ? Icons.star : Icons.star_border,
                      color: Colors.amber, size: 36,
                    ),
                  )),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    controller: _reviewCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      hintStyle: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userRating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rating দাও!', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      setState(() {
                        _reviews.insert(0, {
                          'name': 'You',
                          'rating': _userRating,
                          'comment': _reviewCtrl.text.isEmpty ? 'Great food!' : _reviewCtrl.text,
                          'time': 'Just now',
                          'avatar': 'Y',
                        });
                        _userRating = 0;
                        _reviewCtrl.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('✅ Review submitted!', style: GoogleFonts.poppins()), backgroundColor: AppColors.primary),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Submit Review', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('All Reviews', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ..._reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _RatingBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('${(value * 100).toInt()}%', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(review['avatar'], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(review['time'], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(children: List.generate(5, (i) => Icon(i < review['rating'] ? Icons.star : Icons.star_border, color: Colors.amber, size: 14))),
                const SizedBox(height: 6),
                Text(review['comment'], style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
