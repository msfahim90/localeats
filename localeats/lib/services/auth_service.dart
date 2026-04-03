import 'package:flutter/material.dart';

enum UserRole { customer, vendor, admin }

class AuthService extends ChangeNotifier {
  String? _userName;
  String? _userEmail;
  UserRole _role = UserRole.customer;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  UserRole get role => _role;
  String get userName => _userName ?? 'User';
  String get userEmail => _userEmail ?? '';

  Future<String?> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.length < 6) return 'Invalid credentials';
    setState(true);
    await Future.delayed(const Duration(milliseconds: 800));

    // Demo role detection
    if (email.contains('admin')) {
      _role = UserRole.admin;
    } else if (email.contains('vendor')) {
      _role = UserRole.vendor;
    } else {
      _role = UserRole.customer;
    }

    _isLoggedIn = true;
    _userName = email.split('@')[0];
    _userEmail = email;
    setState(false);
    return null;
  }

  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
    String? businessName,
    String? businessType,
  }) async {
    if (email.isEmpty || password.length < 6 || name.isEmpty) {
      return 'Please fill all fields';
    }
    setState(true);
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _role = role == 'vendor' ? UserRole.vendor
        : role == 'admin' ? UserRole.admin
        : UserRole.customer;
    setState(false);
    return null;
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _role = UserRole.customer;
    notifyListeners();
  }

  void setState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
