
import 'package:flutter/material.dart';

class ShopProfileSeccionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;

  const ShopProfileSeccionHeader({super.key, this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.blue, size: 22),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }
}