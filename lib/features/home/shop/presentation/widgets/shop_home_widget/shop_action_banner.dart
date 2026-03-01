import 'package:flutter/material.dart';

class ShopActionBanner extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;

  const ShopActionBanner({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: iconColor.withAlpha((0.8 * 255).toInt()),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
