import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import 'package:vegetable_ordering_system/features/store_vegetables_tab/domain/entities/product.dart';

class ProductCardProvider extends ChangeNotifier {
  final CartProvider cart;
  final Product? product;
  final List<String>? units;
  final bool isOutOfStock;

  int _quantity;
  String? _selectedUnit;

  ProductCardProvider({
    required this.cart,
    required this.product,
    this.units,
    this.isOutOfStock = false,
  }) : _quantity = 1 {
    final localUnits = units;
    final localProduct = product;
    if (localUnits != null && localUnits.isNotEmpty) {
      _selectedUnit = localUnits.first;
    } else if (localProduct != null) {
      _selectedUnit = localProduct.unit;
    } else {
      _selectedUnit = null;
    }
  }

  int get quantity => _quantity;
  String? get selectedUnit => _selectedUnit;

  void setUnit(String unit) {
    if (_selectedUnit != unit) {
      _selectedUnit = unit;
      notifyListeners();
    }
  }

  void increment() {
    _quantity += 1;
    if (product != null) cart.updateQuantity(product!.id, _quantity);
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity -= 1;
      if (product != null) cart.updateQuantity(product!.id, _quantity);
    } else {
      if (product != null) cart.removeFromCart(product!.id);
      _quantity = 1;
    }
    notifyListeners();
  }

  void addToCart(BuildContext context, {VoidCallback? onAdd}) {
    if (product == null) {
      onAdd?.call();
      return;
    }
    if (isOutOfStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product!.name} is out of stock. Unable to add to cart.',
          ),
        ),
      );
      return;
    }
    final localUnits = units;
    final unitToUse = (selectedUnit != null && selectedUnit!.isNotEmpty)
        ? selectedUnit!
        : (localUnits != null && localUnits.isNotEmpty
              ? localUnits.first
              : (product?.unit ?? ''));
    cart.addToCart(product!, quantity, unitToUse);
    onAdd?.call();
    notifyListeners();
  }
}
