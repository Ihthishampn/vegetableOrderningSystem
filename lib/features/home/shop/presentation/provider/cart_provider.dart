import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/cart_repository_impl.dart';


class CartProvider extends ChangeNotifier {
  final CartRepository _repository;


  CartProvider([CartRepository? repository])
    : _repository = repository ?? CartRepositoryImpl();

  List<CartItem> get cartItems => _repository.cartItems;
  int get itemCount => _repository.itemCount;
  int get totalQuantity => _repository.totalQuantity;

  void addToCart(Product product, int quantity, String unit) {
    _repository.addToCart(product, quantity, unit);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    _repository.updateQuantity(productId, newQuantity);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _repository.removeFromCart(productId);
    notifyListeners();
  }

  void clearCart() {
    _repository.clearCart();
    notifyListeners();
  }

  Map<String, dynamic> getCartSummary() => _repository.getCartSummary();
}
