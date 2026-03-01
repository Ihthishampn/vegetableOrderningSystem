import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

import 'status_badge.dart';

class OrderListItem extends StatelessWidget {
  final Order order;

  final VoidCallback? onTap;

  const OrderListItem({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final orderId = order.id;
    final status = order.status.toString().split('.').last;
    final itemCount = order.items.length;
    final createdAt = order.createdAt;

    String dateText() {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }

    Widget child = Container(
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
          Text(
            '$itemCount Items',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateText(),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: child);
    }
    return child;
  }
}
