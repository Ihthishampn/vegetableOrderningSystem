import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

/// Represents a cart item with quantity and unit selection
class CartItem {
  final Product product;
  final int quantity;
  final String selectedUnit;

  CartItem({
    required this.product,
    required this.quantity,
    required this.selectedUnit,
  });

  CartItem copyWith({Product? product, int? quantity, String? selectedUnit}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedUnit: selectedUnit ?? this.selectedUnit,
    );
  }
}

/// Manages shopping cart state for the shop user
class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  /// Get cart item count
  int get itemCount => _cartItems.length;

  /// Get total number of items (sum of quantities)
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Add a product to cart or increase quantity if already in cart
  void addToCart(Product product, int quantity, String unit) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if product already in cart
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
        selectedUnit: unit,
      );
    } else {
      // Add new item to cart
      _cartItems.add(
        CartItem(product: product, quantity: quantity, selectedUnit: unit),
      );
    }
    notifyListeners();
  }

  /// Update quantity of cart item
  void updateQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
      notifyListeners();
    }
  }

  /// Remove an item from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Clear entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  /// Get cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': _cartItems.length,
      'totalQuantity': totalQuantity,
      'items': _cartItems,
    };
  }
}
