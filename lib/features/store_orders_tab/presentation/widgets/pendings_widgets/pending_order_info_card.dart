

import 'package:flutter/material.dart';

import 'info_row.dart';

class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: const [
          InfoRow(label: "Order ID", value: "ORD001", color: Colors.blue),
          InfoRow(
            label: "Shop",
            value: "Green Valley Wholesale",
            icon: Icons.store_outlined,
          ),
          InfoRow(
            label: "Order Date",
            value: "24/11/2025, 02:30am",
            icon: Icons.calendar_today_outlined,
          ),
          InfoRow(
            label: "Items",
            value: "5 Items",
            icon: Icons.layers_outlined,
          ),
        ],
      ),
    );
  }
}