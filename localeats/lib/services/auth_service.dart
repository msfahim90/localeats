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
    if (user != null) await _loadUserData(user.uid);
    else { _userData = {}; _role = UserRole.customer; }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _userData = doc.data() ?? {};
        final r = _userData['role'] ?? 'customer';
        _role = r == 'admin' ? UserRole.admin : r == 'vendor' ? UserRole.vendor : UserRole.customer;
      }
    } catch (e) { debugPrint('Load error: $e'); }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true; notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      _isLoading = false; notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false; notifyListeners();
      switch (e.code) {
        case 'user-not-found': return 'No account found with this email';
        case 'wrong-password': return 'Incorrect password';
        case 'invalid-credential': return 'Invalid email or password';
        case 'invalid-email': return 'Invalid email address';
        default: return 'Login failed: ${e.code}';
      }
    } catch (e) { _isLoading = false; notifyListeners(); return 'Login failed: $e'; }
  }

  Future<String?> registerWithEmail({
    required String email, required String password,
    required String name, required String role,
    String? businessName, String? businessType,
  }) async {
    try {
      _isLoading = true; notifyListeners();
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      await cred.user!.updateDisplayName(name);
      final data = {
        'name': name, 'email': email.trim(), 'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'addresses': [], 'totalOrders': 0,
      };
      await _db.collection('users').doc(cred.user!.uid).set(data);
      _isLoading = false; notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false; notifyListeners();
      switch (e.code) {
        case 'email-already-in-use': return 'Account already exists with this email';
        case 'weak-password': return 'Password must be at least 6 characters';
        case 'invalid-email': return 'Invalid email address';
        case 'operation-not-allowed': return 'Email sign-up is disabled. Enable it in Firebase Console';
        default: return 'Registration failed: ${e.code}';
      }
    } catch (e) { _isLoading = false; notifyListeners(); return 'Registration failed: $e'; }
  }

  // Google Sign In (stub - shows message)
  Future<String?> signInWithGoogle() async {
    return 'Google Sign In requires SHA-1 setup. Use Email login for now.';
  }

  // Phone OTP
  Future<String?> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    try {
      _isLoading = true; notifyListeners();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _isLoading = false; notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false; notifyListeners();
          debugPrint('Phone verify failed: ${e.code}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _isLoading = false; notifyListeners();
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );
      return null;
    } catch (e) {
      _isLoading = false; notifyListeners();
      return 'Failed to send OTP: $e';
    }
  }

  Future<String?> verifyOTP(String verificationId, String otp, String phone) async {
    try {
      _isLoading = true; notifyListeners();
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final cred = await _auth.signInWithCredential(credential);
      // Save user if new
      final doc = await _db.collection('users').doc(cred.user!.uid).get();
      if (!doc.exists) {
        await _db.collection('users').doc(cred.user!.uid).set({
          'name': 'User', 'email': '', 'phone': phone, 'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(), 'addresses': [], 'totalOrders': 0,
        });
      }
      _isLoading = false; notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false; notifyListeners();
      if (e.code == 'invalid-verification-code') return 'Invalid OTP code';
      return 'Verification failed: ${e.code}';
    } catch (e) { _isLoading = false; notifyListeners(); return 'Verification failed: $e'; }
  }

  Future<void> resetPassword(String email) async {
    try { await _auth.sendPasswordResetEmail(email: email.trim()); }
    catch (e) { debugPrint('Reset error: $e'); }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    try {
      await _db.collection('users').doc(_user!.uid).update(data);
      _userData.addAll(data);
      if (data.containsKey('name')) await _user!.updateDisplayName(data['name']);
      notifyListeners();
    } catch (e) { debugPrint('Update error: $e'); }
  }

  Future<void> saveAddress({
    required String houseNumber, required String apartment,
    required String area, required String city,
    required String instructions, required String label,
  }) async {
    if (_user == null) return;
    try {
      final address = {
        'houseNumber': houseNumber, 'apartment': apartment,
        'area': area, 'city': city, 'instructions': instructions, 'label': label,
      };
      await _db.collection('users').doc(_user!.uid).update({
        'addresses': FieldValue.arrayUnion([address]),
      });
      if (_userData['addresses'] == null) _userData['addresses'] = [];
      (_userData['addresses'] as List).add(address);
      notifyListeners();
    } catch (e) { debugPrint('Address error: $e'); }
  }

  Future<void> signOut() async { await _auth.signOut(); }
}
