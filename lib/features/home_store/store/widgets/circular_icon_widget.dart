import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final IconData icon;
  const CircularIcon({super.key, required this.icon});

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
          onPressed: () {},
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}