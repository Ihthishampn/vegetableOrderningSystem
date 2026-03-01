import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';
import '../widgets/order_now_widgets/empty_cart_view.dart';
import '../widgets/order_now_widgets/order_content_view.dart';

class OrderNowScreen extends StatelessWidget {
  final CartProvider? cartProvider;

  const OrderNowScreen({super.key, this.cartProvider});

  @override
  Widget build(BuildContext context) {
    if (cartProvider != null) {
      return ChangeNotifierProvider.value(
        value: cartProvider!,
        child: _buildScaffold(context),
      );
    }
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Summary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.cartItems.isEmpty) {
            return EmptyCartView(
              onContinueShopping: () => Navigator.pop(context),
            );
          }

          return OrderContentView(
            cartProvider: cart,
          );
        },
      ),
    );
  }
}
