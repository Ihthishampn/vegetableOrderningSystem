
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  final int index;
  final String name;
  final String quantity;

  const OrderItemRow({
    super.key,
    required this.index,
    required this.name,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "$index $name",
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            quantity,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}