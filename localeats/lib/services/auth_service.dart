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
        _role = roleStr == 'admin'
            ? UserRole.admin
            : roleStr == 'vendor'
                ? UserRole.vendor
                : UserRole.customer;
      }
    } catch (e) {
      debugPrint('Load user error: $e');
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await _loadUserData(cred.user!.uid);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('SignIn error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'invalid-credential':
          return 'Invalid email or password';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Try again later';
        default:
          return 'Login failed: ${e.code}';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('SignIn unknown error: $e');
      return 'Login failed: $e';
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

      debugPrint('Starting registration for: $email');

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint('Firebase Auth success: ${cred.user!.uid}');

      await cred.user!.updateDisplayName(name);

      final userData = {
        'name': name,
        'email': email.trim(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'addresses': [],
        'totalOrders': 0,
      };

      await _db.collection('users').doc(cred.user!.uid).set(userData);
      debugPrint('Firestore save success');

      _userData = userData;
      _user = cred.user;
      _role = role == 'admin'
          ? UserRole.admin
          : role == 'vendor'
              ? UserRole.vendor
              : UserRole.customer;

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Register FirebaseAuth error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'Account already exists with this email';
        case 'weak-password':
          return 'Password must be at least 6 characters';
        case 'invalid-email':
          return 'Invalid email address';
        case 'operation-not-allowed':
          return 'Email registration is not enabled. Please contact support.';
        default:
          return 'Registration failed: ${e.code}';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Register unknown error: $e');
      return 'Registration failed: $e';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      debugPrint('Reset password error: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    try {
      await _db.collection('users').doc(_user!.uid).update(data);
      _userData.addAll(data);
      if (data.containsKey('name')) {
        await _user!.updateDisplayName(data['name']);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Update profile error: $e');
    }
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
    try {
      final address = {
        'houseNumber': houseNumber,
        'apartment': apartment,
        'area': area,
        'city': city,
        'instructions': instructions,
        'label': label,
      };
      await _db.collection('users').doc(_user!.uid).update({
        'addresses': FieldValue.arrayUnion([address]),
      });
      if (_userData['addresses'] == null) _userData['addresses'] = [];
      (_userData['addresses'] as List).add(address);
      notifyListeners();
    } catch (e) {
      debugPrint('Save address error: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
