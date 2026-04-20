import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../services/seed_data.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _vendors = [
    {'name': "Mama's Kitchen", 'owner': 'Fatema Begum', 'status': 'Active', 'orders': 127, 'revenue': 28400, 'rating': 4.8, 'emoji': '🏠', 'joined': 'Jan 2024'},
    {'name': 'Dhaka Deli', 'owner': 'Karim Ahmed', 'status': 'Active', 'orders': 89, 'revenue': 19800, 'rating': 4.6, 'emoji': '🍛', 'joined': 'Feb 2024'},
    {'name': 'Burger Express', 'owner': 'Rahim Khan', 'status': 'Active', 'orders': 64, 'revenue': 12300, 'rating': 4.5, 'emoji': '🍔', 'joined': 'Mar 2024'},
    {'name': 'Asian Garden', 'owner': 'Li Wei', 'status': 'Pending', 'orders': 0, 'revenue': 0, 'rating': 0.0, 'emoji': '🍜', 'joined': 'Today'},
    {'name': 'Sweet Corner', 'owner': 'Nusrat Jahan', 'status': 'Suspended', 'orders': 201, 'revenue': 15600, 'rating': 4.9, 'emoji': '🍰', 'joined': 'Dec 2023'},
  ];

  final List<Map<String, dynamic>> _users = [
    {'name': 'Shahriar Fahim', 'email': 'shahriar@pust.edu', 'orders': 12, 'spent': 2450, 'joined': 'Jan 2024', 'status': 'Active'},
    {'name': 'Anika Tabassum', 'email': 'anika@pust.edu', 'orders': 8, 'spent': 1680, 'joined': 'Feb 2024', 'status': 'Active'},
    {'name': 'Rahim Hossain', 'email': 'rahim@gmail.com', 'orders': 23, 'spent': 5200, 'joined': 'Dec 2023', 'status': 'Active'},
    {'name': 'Sumaiya Khan', 'email': 'sumaiya@gmail.com', 'orders': 5, 'spent': 890, 'joined': 'Mar 2024', 'status': 'Inactive'},
  ];

  final List<Map<String, dynamic>> _disputes = [
    {'id': '#D-001', 'user': 'Rahim H.', 'vendor': "Mama's Kitchen", 'issue': 'Food not delivered', 'status': 'Open', 'amount': 220},
    {'id': '#D-002', 'user': 'Sumaiya K.', 'vendor': 'Dhaka Deli', 'issue': 'Wrong order received', 'status': 'Resolved', 'amount': 150},
    {'id': '#D-003', 'user': 'Farhan M.', 'vendor': 'Burger Express', 'issue': 'Late delivery (45 min)', 'status': 'Open', 'amount': 180},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text('⚙️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('Admin Panel', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text('Owner', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Overview'),
            Tab(icon: Icon(Icons.store, size: 18), text: 'Vendors'),
            Tab(icon: Icon(Icons.people, size: 18), text: 'Users'),
            Tab(icon: Icon(Icons.gavel, size: 18), text: 'Disputes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverview(),
          _buildVendors(),
          _buildUsers(),
          _buildDisputes(),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _AdminStatCard('৳1,24,800', 'Total Revenue', Icons.attach_money, Colors.green),
              _AdminStatCard('487', 'Total Orders', Icons.receipt_long, Colors.blue),
              _AdminStatCard('5', 'Active Vendors', Icons.store, AppColors.primary),
              _AdminStatCard('4', 'Total Users', Icons.people, Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          // Commission summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Commission Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 12),
                _CommissionRow("Mama's Kitchen", 28400, 10),
                _CommissionRow('Dhaka Deli', 19800, 10),
                _CommissionRow('Burger Express', 12300, 10),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Commission', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    Text('৳6,050', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Recent activity
          Text('Recent Activity', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ...[
            {'icon': '🏪', 'text': 'Asian Garden applied for verification', 'time': '10 min ago', 'color': Colors.orange},
            {'icon': '📦', 'text': 'Order #4821 delivered successfully', 'time': '25 min ago', 'color': AppColors.primary},
            {'icon': '⚠️', 'text': 'Dispute #D-003 opened by Farhan M.', 'time': '1 hour ago', 'color': Colors.red},
            {'icon': '👤', 'text': 'New user registered: Sumaiya K.', 'time': '2 hours ago', 'color': Colors.blue},
          ].map((a) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Text(a['icon'].toString(), style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(a['text'].toString(), style: GoogleFonts.poppins(fontSize: 12))),
                Text(a['time'].toString(), style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildVendors() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _vendors.length,
      itemBuilder: (_, i) {
        final v = _vendors[i];
        final statusColor = v['status'] == 'Active' ? AppColors.primary
            : v['status'] == 'Pending' ? Colors.orange : Colors.red;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(v['emoji'], style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        Text('Owner: ${v['owner']}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
                        Text('Joined: ${v['joined']}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(v['status'], style: GoogleFonts.poppins(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MiniStat('${v['orders']}', 'Orders'),
                  _MiniStat('৳${v['revenue']}', 'Revenue'),
                  _MiniStat('${v['rating']} ⭐', 'Rating'),
                ],
              ),
              const SizedBox(height: 12),
              if (v['status'] == 'Pending')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() => v['status'] = 'Active'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text('Approve', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => v['status'] = 'Suspended'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text('Reject', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.red)),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final newStatus = v['status'] == 'Active' ? 'Suspended' : 'Active';
                          setState(() => v['status'] = newStatus);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${v['name']} $newStatus!', style: GoogleFonts.poppins()), backgroundColor: AppColors.primary),
                          );
                        },
                        icon: Icon(v['status'] == 'Active' ? Icons.block : Icons.check_circle, size: 16),
                        label: Text(v['status'] == 'Active' ? 'Suspend' : 'Activate',
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: v['status'] == 'Active' ? Colors.red : AppColors.primary,
                          side: BorderSide(color: v['status'] == 'Active' ? Colors.red : AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsers() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (_, i) {
        final u = _users[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Text(u['name'].toString()[0], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    Text(u['email'], style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
                    Text('${u['orders']} orders • ৳${u['spent']} spent', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: u['status'] == 'Active' ? AppColors.lightGreen : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(u['status'], style: GoogleFonts.poppins(fontSize: 10, color: u['status'] == 'Active' ? AppColors.primary : AppColors.textGray, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 4),
                  Text(u['joined'], style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDisputes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _disputes.length,
      itemBuilder: (_, i) {
        final d = _disputes[i];
        final isOpen = d['status'] == 'Open';
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isOpen ? Colors.red.withOpacity(0.3) : Colors.transparent),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(d['id'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.red.withOpacity(0.1) : AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(d['status'], style: GoogleFonts.poppins(fontSize: 11, color: isOpen ? Colors.red : AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${d['user']} vs ${d['vendor']}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(d['issue'], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
              Text('Amount: ৳${d['amount']}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primary)),
              if (isOpen) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() => d['status'] = 'Resolved'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text('Resolve', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text('Refund', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _AdminStatCard(this.value, this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray)),
        ],
      ),
    );
  }
}

class _CommissionRow extends StatelessWidget {
  final String name;
  final int revenue, rate;
  const _CommissionRow(this.name, this.revenue, this.rate);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.poppins(fontSize: 13)),
          Text('৳${(revenue * rate / 100).toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value, label;
  const _MiniStat(this.value, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray)),
      ],
    );
  }
}
