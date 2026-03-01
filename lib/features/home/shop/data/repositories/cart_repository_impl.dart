import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';
import 'cart_repository.dart';


class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _cartItems = [];

  @override
  List<CartItem> get cartItems => _cartItems;

  @override
  int get itemCount => _cartItems.length;

  @override
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void addToCart(Product product, int quantity, String unit) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
        selectedUnit: unit,
      );
    } else {
      _cartItems.add(
        CartItem(product: product, quantity: quantity, selectedUnit: unit),
      );
    }
   
  }

  @override
  void updateQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
     
    }
  }

  @override
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
   
  }

  @override
  void clearCart() {
    _cartItems.clear();
  }

  @override
  Map<String, dynamic> getCartSummary() {
    return {
      'itemCount': _cartItems.length,
      'totalQuantity': totalQuantity,
      'items': _cartItems,
    };
  }
}
