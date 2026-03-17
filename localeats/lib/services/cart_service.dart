import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _vendorId;
  String _couponCode = '';
  double _discount = 0;

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get deliveryFee => 40;
  String get appliedCoupon => _couponCode;

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get discountAmount => subtotal * _discount;

  double get total => subtotal + deliveryFee - discountAmount;

  void addItem(CartItem item, String vendorId) {
    if (_vendorId != null && _vendorId != vendorId) {
      _items.clear();
    }
    _vendorId = vendorId;
    final existing = _items.where((i) => i.id == item.id);
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.remove(item);
      }
    }
    notifyListeners();
  }

  bool applyCoupon(String code) {
    if (code.toUpperCase() == 'LOCALEATS10') {
      _couponCode = code.toUpperCase();
      _discount = 0.10;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearCart() {
    _items.clear();
    _vendorId = null;
    _couponCode = '';
    _discount = 0;
    notifyListeners();
  }
}
