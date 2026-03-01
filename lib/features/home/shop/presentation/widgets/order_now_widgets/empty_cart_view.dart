import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const EmptyCartView({
    super.key,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onContinueShopping,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C79FF),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
