
import 'package:flutter/material.dart';

class ShopProfileLogOutButton extends StatelessWidget {
  const ShopProfileLogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Logout logic
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Logout",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
