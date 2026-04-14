import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _houseCtrl = TextEditingController();
  final _apartmentCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  String _selectedLabel = 'home';
  String _detectedArea = 'Madla Road';
  String _detectedCity = 'Bogra';

  final List<Map<String, dynamic>> _labels = [
    {'id': 'home', 'icon': Icons.home_outlined, 'label': 'Home'},
    {'id': 'work', 'icon': Icons.work_outline, 'label': 'Work'},
    {'id': 'favorite', 'icon': Icons.favorite_outline, 'label': 'Favorite'},
    {'id': 'other', 'icon': Icons.add, 'label': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Map area
          Container(
            height: 180,
            width: double.infinity,
            color: Colors.green.shade50,
            child: Stack(
              children: [
                // Map grid
                CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: _FullMapPainter(),
                ),
                // Back button
                Positioned(
                  top: 40, left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                ),
                // Pin
                const Center(
                  child: Icon(Icons.location_on, color: Color(0xFFE91E8C), size: 40),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add a new address',
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Detected location
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Color(0xFFE91E8C)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_detectedArea,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(_detectedCity,
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('House Number',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  _buildField(_houseCtrl, 'House Number'),
                  const SizedBox(height: 10),
                  _buildField(_apartmentCtrl, 'Apartment name'),
                  const SizedBox(height: 20),
                  Text('Delivery instructions',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Please give us more information about your address',
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _instructionsCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '(Optional) Floor or Apt No or tell us how...',
                      hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade400, fontSize: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFE91E8C), width: 2)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Add a label',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: _labels.map((l) => GestureDetector(
                      onTap: () => setState(() => _selectedLabel = l['id']),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedLabel == l['id']
                              ? const Color(0xFFE91E8C).withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: _selectedLabel == l['id']
                                ? const Color(0xFFE91E8C)
                                : Colors.grey.shade300,
                            width: _selectedLabel == l['id'] ? 2 : 1,
                          ),
                        ),
                        child: Icon(l['icon'],
                            color: _selectedLabel == l['id']
                                ? const Color(0xFFE91E8C)
                                : Colors.grey.shade600),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Save button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_houseCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter house number',
                            style: GoogleFonts.poppins()),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E8C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Save and continue',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE91E8C), width: 2)),
      ),
    );
  }
}

class _FullMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.shade200..strokeWidth = 0.8;
    for (double i = 0; i < size.width; i += 25) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 25) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    final road = Paint()..color = Colors.white..strokeWidth = 10..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, 90), Offset(size.width, 90), road);
    canvas.drawLine(const Offset(120, 0), Offset(120, size.height), road);
  }
  @override
  bool shouldRepaint(_) => false;
}
