import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';


abstract class CartRepository {
  List<CartItem> get cartItems;

  int get itemCount;

  int get totalQuantity;

  
  void addToCart(Product product, int quantity, String unit);

 
  void updateQuantity(String productId, int newQuantity);

  void removeFromCart(String productId);

  void clearCart();

  Map<String, dynamic> getCartSummary();
}

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
