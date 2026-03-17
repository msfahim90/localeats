import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Vendor>> getNearbyVendors() async {
    final snap = await _db.collection('vendors').limit(10).get();
    return snap.docs.map((d) => Vendor.fromMap(d.data(), d.id)).toList();
  }

  Future<Vendor?> getVendor(String id) async {
    final doc = await _db.collection('vendors').doc(id).get();
    if (doc.exists) return Vendor.fromMap(doc.data()!, doc.id);
    return null;
  }

  Future<String> placeOrder(Map<String, dynamic> orderData) async {
    final ref = await _db.collection('orders').add({
      ...orderData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'placed',
    });
    return ref.id;
  }

  Stream<DocumentSnapshot> trackOrder(String orderId) {
    return _db.collection('orders').doc(orderId).snapshots();
  }
}
