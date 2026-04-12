import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all approved vendors
  Stream<List<Map<String, dynamic>>> getVendors() {
    return _db
        .collection('vendors')
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList());
  }

  // Place order
  Future<String> placeOrder({
    required String userId,
    required String vendorId,
    required String vendorName,
    required List<Map<String, dynamic>> items,
    required double total,
    required double deliveryFee,
    required String paymentMethod,
  }) async {
    final ref = await _db.collection('orders').add({
      'userId': userId,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'items': items,
      'subtotal': total - deliveryFee,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': 'placed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update vendor order count
    await _db.collection('vendors').doc(vendorId).update({
      'totalOrders': FieldValue.increment(1),
      'revenue': FieldValue.increment(total),
    });

    return ref.id;
  }

  // Get user orders
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList());
  }

  // Get vendor orders
  Stream<List<Map<String, dynamic>>> getVendorOrders(String vendorId) {
    return _db
        .collection('orders')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList());
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
  }

  // Add review
  Future<void> addReview({
    required String vendorId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    await _db.collection('vendors').doc(vendorId).collection('reviews').add({
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update vendor rating
    final reviews = await _db
        .collection('vendors')
        .doc(vendorId)
        .collection('reviews')
        .get();
    final avgRating = reviews.docs
        .map((d) => (d.data()['rating'] as num).toDouble())
        .reduce((a, b) => a + b) / reviews.docs.length;

    await _db.collection('vendors').doc(vendorId).update({
      'rating': avgRating,
      'reviewCount': reviews.docs.length,
    });
  }
}
