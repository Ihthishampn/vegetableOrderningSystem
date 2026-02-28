
import 'package:flutter/material.dart';

class SummaryItemRow extends StatelessWidget {
  final String label;
  final String quantity;

  const SummaryItemRow({super.key, required this.label, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          Text(quantity, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }
}