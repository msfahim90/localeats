import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {'icon': '🛵', 'title': 'Order on the way!', 'body': 'Rahim is heading to your location. ETA: 12 minutes', 'time': '2 min ago', 'isRead': false, 'color': Color(0xFFE8F5E9)},
    {'icon': '✅', 'title': 'Order confirmed!', 'body': "Mama's Kitchen confirmed your order #LE-4821", 'time': '15 min ago', 'isRead': false, 'color': Color(0xFFE8F5E9)},
    {'icon': '🎉', 'title': 'Special offer!', 'body': '20% off on all Bengali cuisine today only!', 'time': '1 hour ago', 'isRead': true, 'color': Color(0xFFFFF3CD)},
    {'icon': '⭐', 'title': 'Rate your order', 'body': 'How was your Chicken Biryani from Dhaka Deli?', 'time': '2 hours ago', 'isRead': true, 'color': Color(0xFFFFF8E1)},
    {'icon': '🏠', 'title': 'New vendor nearby!', 'body': 'Sweet Corner just joined LocalEats — 0.7 km away', 'time': '1 day ago', 'isRead': true, 'color': Color(0xFFE3F2FD)},
    {'icon': '💰', 'title': 'Coupon earned!', 'body': 'You earned SAVE20 coupon for your next order', 'time': '2 days ago', 'isRead': true, 'color': Color(0xFFF3E5F5)},
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n['isRead']).length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            Text('Notifications', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(10)),
                child: Text('$unread new', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (var n in _notifications) n['isRead'] = true;
            }),
            child: Text('Mark all read', style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 12)),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (_, i) {
          final n = _notifications[i];
          return GestureDetector(
            onTap: () => setState(() => n['isRead'] = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: n['isRead'] ? Colors.white : AppColors.lightGreen,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: n['isRead'] ? Colors.transparent : AppColors.primary.withOpacity(0.2),
                ),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: n['color'], borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(n['icon'], style: const TextStyle(fontSize: 22))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(n['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                            if (!n['isRead'])
                              Container(
                                width: 8, height: 8,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(n['body'], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray, height: 1.4)),
                        const SizedBox(height: 4),
                        Text(n['time'], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
