import 'package:flutter/material.dart';

class MyRow extends StatelessWidget {
  final String label, value;
  final IconData? icon;
  final Color? vColor;
  const MyRow({super.key, required this.label, required this.value, this.icon, this.vColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 18, color: Colors.grey),
          if (icon != null) const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: vColor ?? Colors.black)
          ),
        ],
      ),
    );
  }
}