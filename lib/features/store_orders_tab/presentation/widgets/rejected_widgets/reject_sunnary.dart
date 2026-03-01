import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'detail_row.dart';

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class RejectedSummaryCard extends StatelessWidget {
  final Order order;
  const RejectedSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
          DetailRow(
            label: "Order ID",
            value: order.id,
            valueColor: Colors.blue,
          ),
          DetailRow(
            label: "Customer",
            value: order.customerName,
            icon: Icons.person_outline,
          ),
          DetailRow(
            label: "Order Date",
            value: date,
            icon: Icons.calendar_today_outlined,
          ),
          DetailRow(
            label: "Items",
            value: '${order.items.length} Items',
            icon: Icons.layers_outlined,
          ),
          Divider(height: 24),
          DetailRow(
            label: "Status",
            value: _capitalize(order.status.toString().split('.').last),
            valueColor: Colors.red,
            icon: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }
}
