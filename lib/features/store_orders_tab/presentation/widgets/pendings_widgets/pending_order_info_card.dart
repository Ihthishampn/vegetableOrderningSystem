import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

import 'info_row.dart';

class OrderInfoCard extends StatelessWidget {
  final Order order;
  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final itemCount = order.items.length;
    final date =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}, ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}${order.createdAt.hour >= 12 ? 'pm' : 'am'}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          InfoRow(label: "Order ID", value: order.id, color: Colors.blue),
          InfoRow(
            label: "Customer",
            value: order.customerName,
            icon: Icons.person_outline,
          ),
          InfoRow(
            label: "Order Date",
            value: date,
            icon: Icons.calendar_today_outlined,
          ),
          InfoRow(
            label: "Items",
            value: "$itemCount Items",
            icon: Icons.layers_outlined,
          ),
        ],
      ),
    );
  }
}
