import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});
  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isOpen = true;

  final List<Map<String, dynamic>> _orders = [
    {'id': '#4821', 'customer': 'Shahriar F.', 'items': 'Biryani ×2, Paratha ×1', 'total': 544, 'status': 'New', 'time': '2:30 PM'},
    {'id': '#4820', 'customer': 'Anika T.', 'items': 'Dal Makhani ×1', 'total': 150, 'status': 'Preparing', 'time': '2:15 PM'},
    {'id': '#4819', 'customer': 'Rahim H.', 'items': 'Beef Kacchi ×2', 'total': 560, 'status': 'On the way', 'time': '2:00 PM'},
    {'id': '#4818', 'customer': 'Sumaiya K.', 'items': 'Biryani ×1', 'total': 220, 'status': 'Delivered', 'time': '1:45 PM'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  Color _statusColor(String s) {
    switch (s) {
      case 'New': return Colors.blue;
      case 'Preparing': return Colors.orange;
      case 'On the way': return AppColors.secondary;
      case 'Delivered': return AppColors.primary;
      default: return AppColors.textGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Vendor Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              Text(_isOpen ? 'Open' : 'Closed', style: GoogleFonts.poppins(fontSize: 12, color: _isOpen ? AppColors.primary : Colors.red)),
              Switch(value: _isOpen, onChanged: (v) => setState(() => _isOpen = v), activeColor: AppColors.primary),
            ],
          ),
        ],
        elevation: 0, backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGray,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [Tab(text: 'Overview'), Tab(text: 'Orders'), Tab(text: 'Menu')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Stats
                Row(
                  children: [
                    Expanded(child: _StatCard('৳2,840', 'Today\'s Sales', Icons.attach_money, Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard('12', 'Orders', Icons.receipt, Colors.blue)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _StatCard('4.8 ⭐', 'Rating', Icons.star, Colors.amber)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard('127', 'Reviews', Icons.reviews, Colors.purple)),
                  ],
                ),
                const SizedBox(height: 20),
                // Recent orders preview
                Text('Recent Orders', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ..._orders.take(3).map((o) => _OrderCard(order: o, statusColor: _statusColor(o['status']))),
              ],
            ),
          ),
          // Orders tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _orders.length,
            itemBuilder: (_, i) => _OrderCard(order: _orders[i], statusColor: _statusColor(_orders[i]['status']), showActions: true),
          ),
          // Menu tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...['Chicken Biryani', 'Dal Makhani', 'Paratha Set', 'Beef Kacchi', 'Mishti Doi'].map((item) =>
                Container(
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
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: AppColors.lightOrange, borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('🍚', style: TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            Text('Available', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard(this.value, this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Color statusColor;
  final bool showActions;
  const _OrderCard({required this.order, required this.statusColor, this.showActions = false});
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order['id']} • ${order['customer']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(order['status'], style: GoogleFonts.poppins(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(order['items'], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['time'], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
              Text('৳${order['total']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          if (showActions && order['status'] == 'New') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Accept', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Reject', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.red)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
