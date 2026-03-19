import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({super.key, required this.total});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'cod';
  bool _processing = false;
  final _phoneCtrl = TextEditingController();

  final List<Map<String, dynamic>> _methods = [
    {'id': 'cod', 'name': 'Cash on Delivery', 'emoji': '💵', 'desc': 'Delivery র সময় cash দিন', 'color': Color(0xFFE8F5E9)},
    {'id': 'bkash', 'name': 'bKash', 'emoji': '🩷', 'desc': 'bKash এ payment করুন', 'color': Color(0xFFFCE4EC)},
    {'id': 'nagad', 'name': 'Nagad', 'emoji': '🧡', 'desc': 'Nagad এ payment করুন', 'color': Color(0xFFFFF3E0)},
    {'id': 'rocket', 'name': 'Rocket', 'emoji': '💜', 'desc': 'Dutch-Bangla Rocket', 'color': Color(0xFFEDE7F6)},
  ];

  Future<void> _processPayment() async {
    if ((_selectedMethod == 'bkash' || _selectedMethod == 'nagad' || _selectedMethod == 'rocket')
        && _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number দাও!', style: GoogleFonts.poppins()), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _processing = false);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(total: widget.total),
      ));
    }
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
        title: Text('Payment', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Amount card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Amount', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                          Text('৳${widget.total.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Text('💳', style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Payment Method', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ..._methods.map((m) => GestureDetector(
                  onTap: () => setState(() => _selectedMethod = m['id']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedMethod == m['id'] ? m['color'] : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _selectedMethod == m['id'] ? AppColors.primary : Colors.grey.shade200,
                        width: _selectedMethod == m['id'] ? 2 : 1,
                      ),
                      boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        Text(m['emoji'], style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              Text(m['desc'], style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray)),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: m['id'],
                          groupValue: _selectedMethod,
                          onChanged: (v) => setState(() => _selectedMethod = v!),
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                )),
                // Phone number for mobile banking
                if (_selectedMethod != 'cod') ...[
                  const SizedBox(height: 8),
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
                        Text('Phone Number', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '01XXXXXXXXX',
                            hintStyle: GoogleFonts.poppins(color: AppColors.textGray),
                            prefixIcon: const Icon(Icons.phone, color: AppColors.textGray),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _processing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _processing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                          const SizedBox(width: 12),
                          Text('Processing...', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      )
                    : Text(
                        _selectedMethod == 'cod' ? 'Place Order ৳${widget.total.toStringAsFixed(0)}' : 'Pay ৳${widget.total.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
