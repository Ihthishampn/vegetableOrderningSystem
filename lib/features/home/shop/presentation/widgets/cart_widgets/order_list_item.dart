
import 'package:flutter/material.dart';

import 'status_badge.dart';

class OrderListItem extends StatelessWidget {
  final String orderId;
  final String status;
  final String date;
  final String? deliveryDate;

  const OrderListItem({
    super.key,
    required this.orderId,
    required this.status,
    required this.date,
    this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "5 Items",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          if (deliveryDate != null) ...[
            Text(
              "Ordered Date: $date",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              "Delivery Date: $deliveryDate",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
