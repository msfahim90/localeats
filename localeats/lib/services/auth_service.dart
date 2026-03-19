import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String? _userName;
  String? _userEmail;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  Future<String?> signInWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userName = email.split('@')[0];
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return null;
    }
    _isLoading = false;
    notifyListeners();
    return 'Invalid email or password';
  }

  Future<String?> registerWithEmail(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return null;
    }
    _isLoading = false;
    notifyListeners();
    return 'Please fill all fields correctly';
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }
}
