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
        case 'invalid-credential': return 'Email বা Incorrect password';
        default: return 'Login failed: ${e.message}';
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
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      await cred.user!.updateDisplayName(name);

      final userData = {
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      };
      if (role == 'vendor') {
        userData['businessName'] = businessName ?? name;
        userData['businessType'] = businessType ?? 'Restaurant';
        userData['isApproved'] = false as Object;
        userData['isOpen'] = false as Object;
        userData['rating'] = 0.0 as Object;
        userData['totalOrders'] = 0 as Object;
      }
      await _db.collection('users').doc(cred.user!.uid).set(userData);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.code) {
        case 'email-already-in-use': return 'Email already in use';
        case 'weak-password': return 'Password must be at least 6 characters';
        default: return 'Registration failed: ${e.message}';
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
