import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'admin_panel_screen.dart';
import 'vendor_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _showEditProfile() {
    final auth = context.read<AuthService>();
    final nameCtrl = TextEditingController(text: auth.userName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Edit Profile', style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await auth.updateProfile({'name': nameCtrl.text.trim()});
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated!',
                          style: GoogleFonts.poppins()),
                          backgroundColor: AppColors.primary));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Save Changes',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showChangePassword() {
    final auth = context.read<AuthService>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Password',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
            'We will send a password reset email to ${auth.userEmail}',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.resetPassword(auth.userEmail);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reset email sent!',
                      style: GoogleFonts.poppins()),
                      backgroundColor: AppColors.primary));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Send Email',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('🚧', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(feature, style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Coming soon!', style: GoogleFonts.poppins(
                color: AppColors.textGray)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('OK', style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My Profile', style: GoogleFonts.poppins(
            color: AppColors.textDark, fontWeight: FontWeight.bold)),
        actions: [
          GestureDetector(
            onTap: () => themeService.toggleTheme(),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? Colors.yellow.shade100 : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? Colors.orange : Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(isDark ? 'Light' : 'Dark',
                      style: GoogleFonts.poppins(
                          color: isDark ? Colors.orange : Colors.white,
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      auth.userName.isNotEmpty
                          ? auth.userName[0].toUpperCase() : 'U',
                      style: GoogleFonts.poppins(
                          fontSize: 32, color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: _showEditProfile,
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(auth.userName, style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold)),
            Text(auth.userEmail, style: GoogleFonts.poppins(
                color: AppColors.textGray, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                auth.role == UserRole.admin ? '⚙️ Admin'
                    : auth.role == UserRole.vendor ? '🍽️ Vendor'
                    : '⭐ Customer',
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // Account Settings
            _SectionTitle('Account Settings'),
            _ProfileMenuItem(
              icon: Icons.person_outline,
              label: 'Edit Profile',
              subtitle: 'Update your name and info',
              onTap: _showEditProfile,
            ),
            _ProfileMenuItem(
              icon: Icons.lock_outline,
              label: 'Change Password',
              subtitle: 'Send password reset email',
              onTap: _showChangePassword,
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              subtitle: 'Manage your alerts',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),

            const SizedBox(height: 16),

            // Orders & Favorites
            _SectionTitle('Orders & Favorites'),
            _ProfileMenuItem(
              icon: Icons.receipt_long,
              label: 'My Orders',
              subtitle: 'View order history',
              onTap: () => _showComingSoon('My Orders'),
            ),
            _ProfileMenuItem(
              icon: Icons.favorite_outline,
              label: 'Favorite Vendors',
              subtitle: 'Your saved vendors',
              onTap: () => _showComingSoon('Favorite Vendors'),
            ),
            _ProfileMenuItem(
              icon: Icons.location_on_outlined,
              label: 'Delivery Addresses',
              subtitle: 'Manage your addresses',
              onTap: () => _showComingSoon('Delivery Addresses'),
            ),
            _ProfileMenuItem(
              icon: Icons.payment_outlined,
              label: 'Payment Methods',
              subtitle: 'Manage payment options',
              onTap: () => _showComingSoon('Payment Methods'),
            ),

            const SizedBox(height: 16),

            // Business
            if (auth.role == UserRole.vendor || auth.role == UserRole.admin) ...[
              _SectionTitle('Business'),
              if (auth.role == UserRole.vendor)
                _ProfileMenuItem(
                  icon: Icons.store,
                  label: 'Vendor Dashboard',
                  subtitle: 'Manage your store',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const VendorDashboardScreen())),
                ),
              if (auth.role == UserRole.admin)
                _ProfileMenuItem(
                  icon: Icons.admin_panel_settings,
                  label: 'Admin Panel',
                  subtitle: 'Manage platform',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const AdminPanelScreen())),
                ),
              const SizedBox(height: 16),
            ],

            // Support
            _SectionTitle('Support'),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              label: 'Help & Support',
              subtitle: 'FAQ and contact',
              onTap: () => _showComingSoon('Help & Support'),
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              label: 'About LocalEats',
              subtitle: 'Version 1.0.0',
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'LocalEats',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 LocalEats. All rights reserved.',
              ),
            ),

            const SizedBox(height: 20),

            // Sign out
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await auth.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (_) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text('Sign Out',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: GoogleFonts.poppins(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: AppColors.textGray)),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _ProfileMenuItem({
    required this.icon, required this.label,
    required this.subtitle, required this.onTap});

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
          decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(
            fontSize: 12, color: AppColors.textGray)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textGray),
      ),
    );
  }
}
