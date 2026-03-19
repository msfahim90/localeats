import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'admin_panel_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'referral_screen.dart';
import 'vendor_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showComingSoon(String feature) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('��', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(feature, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('এই feature টি শীঘ্রই আসছে!', style: GoogleFonts.poppins(color: AppColors.textGray)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('ঠিক আছে', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrders() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('My Orders', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _OrderCard(id: '#LE-20240235-4821', vendor: "Mama's Kitchen", items: 'Chicken Biryani × 2', total: '৳544', status: 'Delivered', statusColor: AppColors.primary),
                  _OrderCard(id: '#LE-20240234-3210', vendor: 'Dhaka Deli', items: 'Dal Makhani × 1, Paratha × 2', total: '৳320', status: 'Delivered', statusColor: AppColors.primary),
                  _OrderCard(id: '#LE-20240233-1105', vendor: 'Burger Express', items: 'Chicken Burger × 1', total: '৳180', status: 'Delivered', statusColor: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Profile', style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar with edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Text('SF', style: GoogleFonts.poppins(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('Shahriar Fahim', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text('shahriar@localeats.app', style: GoogleFonts.poppins(color: AppColors.textGray)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(20)),
              child: Text('⭐ Premium Member', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            const SizedBox(height: 24),
            // Stats row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBox(value: '12', label: 'Orders'),
                  _StatBox(value: '3', label: 'Favorites'),
                  _StatBox(value: '৳2,450', label: 'Spent'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Menu items
            _ProfileMenuItem(icon: Icons.receipt_long, label: 'My Orders', subtitle: '12 orders placed', onTap: _showOrders),
            _ProfileMenuItem(icon: Icons.favorite_outline, label: 'Favorite Vendors', subtitle: '3 saved vendors', onTap: () => _showComingSoon('Favorite Vendors')),
            _ProfileMenuItem(icon: Icons.location_on_outlined, label: 'Delivery Addresses', subtitle: 'Bogura, Bangladesh', onTap: () => _showComingSoon('Delivery Addresses')),
            _ProfileMenuItem(icon: Icons.payment_outlined, label: 'Payment Methods', subtitle: 'Add payment method', onTap: () => _showComingSoon('Payment Methods')),
            _ProfileMenuItem(icon: Icons.notifications_outlined, label: 'Notifications', subtitle: 'Manage alerts', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
            _ProfileMenuItem(icon: Icons.help_outline, label: 'Help & Support', subtitle: 'FAQ, Contact us', onTap: () => _showComingSoon('Help & Support')),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 8),
            _ProfileMenuItem(icon: Icons.store, label: 'Vendor Dashboard', subtitle: 'Manage your store', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorDashboardScreen()))),
            _ProfileMenuItem(icon: Icons.admin_panel_settings, label: 'Admin Panel', subtitle: 'Owner controls', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen()))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text('Sign Out', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _ProfileMenuItem({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textGray),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String id;
  final String vendor;
  final String items;
  final String total;
  final String status;
  final Color statusColor;
  const _OrderCard({required this.id, required this.vendor, required this.items, required this.total, required this.status, required this.statusColor});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(vendor, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: GoogleFonts.poppins(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(items, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
              Text(total, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}
