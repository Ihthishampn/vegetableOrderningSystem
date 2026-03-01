import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final String orderId;
  final String storeName;
  final int itemCount;

  const OrderSummaryCard({
    super.key,
    required this.orderId,
    required this.storeName,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E2FF)),
      ),
      child: Column(
        children: [
          _infoRow("Order ID", orderId, isBlue: true),
          const SizedBox(height: 12),
          _infoRow("Store", storeName, icon: Icons.store_outlined),
          const SizedBox(height: 12),
          _infoRow(
            "Items",
            "$itemCount Items",
            icon: Icons.inventory_2_outlined,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
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
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isBlue ? const Color(0xFF4A68FF) : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
