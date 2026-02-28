
import 'package:flutter/material.dart';

class OrderSummaryHeader extends StatelessWidget {
  final String orderId;
  final String storeName;
  final int itemCount;

  const OrderSummaryHeader({
    super.key,
    required this.orderId,
    required this.storeName,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF), // Light blue background from screenshot
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0D9FF)),
      ),
      child: Column(
        children: [
          _buildRow("Order ID", orderId, isBlue: true),
          const SizedBox(height: 12),
          _buildRow("Store", storeName, icon: Icons.store_outlined),
          const SizedBox(height: 12),
          _buildRow(
            "Items",
            "$itemCount Items",
            icon: Icons.inventory_2_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    IconData? icon,
    bool isBlue = false,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isBlue ? const Color(0xFF4A68FF) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
