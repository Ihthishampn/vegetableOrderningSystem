import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final VoidCallback ontap;
  final IconData icon;
  const CircularIcon({super.key, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: ontap,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
