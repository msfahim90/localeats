import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { customer, vendor, admin }

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  UserRole _role = UserRole.customer;
  Map<String, dynamic> _userData = {};
  bool _isLoading = false;

  User? get user => _user;
  UserRole get role => _role;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String get userName => _userData['name'] ?? _user?.displayName ?? 'User';
  String get userEmail => _user?.email ?? '';
  String get userId => _user?.uid ?? '';
  Map<String, dynamic> get userData => _userData;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _loadUserData(user.uid);
    } else {
      _userData = {};
      _role = UserRole.customer;
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data() ?? {};
        final roleStr = _userData['role'] ?? 'customer';
        _role = roleStr == 'admin' ? UserRole.admin
            : roleStr == 'vendor' ? UserRole.vendor
            : UserRole.customer;
      }
    } catch (e) {
      _role = UserRole.customer;
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'user-not-found': return 'Email not found';
        case 'wrong-password': return 'Incorrect password';
        case 'invalid-email': return 'Invalid email address';
        case 'invalid-credential': return 'Invalid email or password';
        default: return 'Login failed. Please try again.';
      }
    }
  }

  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
    String? businessName,
    String? businessType,
    String? phone,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user!.updateDisplayName(name);

      final Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'role': role,
        'phone': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'addresses': [],
        'favoriteVendors': [],
        'totalOrders': 0,
      };

      if (role == 'vendor') {
        userData['businessName'] = businessName ?? name;
        userData['businessType'] = businessType ?? 'Restaurant';
        userData['isApproved'] = false;
        userData['isOpen'] = false;
        userData['rating'] = 0.0;
        userData['totalOrders'] = 0;
        userData['revenue'] = 0;

        await _db.collection('vendors').doc(cred.user!.uid).set({
          'name': businessName ?? name,
          'ownerName': name,
          'ownerEmail': email,
          'ownerId': cred.user!.uid,
          'cuisine': businessType ?? 'Restaurant',
          'rating': 0.0,
          'reviewCount': 0,
          'isApproved': false,
          'isOpen': false,
          'deliveryFee': 40,
          'minDelivery': 15,
          'maxDelivery': 25,
          'menu': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await _db.collection('users').doc(cred.user!.uid).set(userData);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'email-already-in-use': return 'An account already exists with this email';
        case 'weak-password': return 'Password must be at least 6 characters';
        default: return 'Registration failed. Please try again.';
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // ignore
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    await _db.collection('users').doc(_user!.uid).update(data);
    _userData.addAll(data);
    if (data.containsKey('name')) {
      await _user!.updateDisplayName(data['name']);
    }
    notifyListeners();
  }

  Future<void> saveAddress({
    required String houseNumber,
    required String apartment,
    required String area,
    required String city,
    required String instructions,
    required String label,
  }) async {
    if (_user == null) return;
    final address = {
      'houseNumber': houseNumber,
      'apartment': apartment,
      'area': area,
      'city': city,
      'instructions': instructions,
      'label': label,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _db.collection('users').doc(_user!.uid).update({
      'addresses': FieldValue.arrayUnion([address]),
    });
    _userData['addresses'] = [...(_userData['addresses'] ?? []), address];
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
