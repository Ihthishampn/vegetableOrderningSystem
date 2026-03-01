import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/screens/order_now_screen.dart';
import 'package:vegetable_ordering_system/features/home/shop/presentation/provider/cart_provider.dart';

class ShopBottomOrderButton extends StatelessWidget {
  final CartProvider cartProvider;

  const ShopBottomOrderButton({super.key, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrderNowScreen(cartProvider: cartProvider),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        label: const Text(
          "Order Now",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C79FF),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
