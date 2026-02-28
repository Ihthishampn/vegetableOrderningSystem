import 'package:flutter/material.dart';

import 'detail_row.dart';

class RejectedSummaryCard extends StatelessWidget {
  const RejectedSummaryCard({super.key});

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
          DetailRow(label: "Order ID", value: "ORD001", valueColor: Colors.blue),
          DetailRow(label: "Shop", value: "Green Valley Wholesale", icon: Icons.store_outlined),
          DetailRow(label: "Order Date", value: "24/11/2025, 02:30am", icon: Icons.calendar_today_outlined),
          DetailRow(label: "Items", value: "5 Items", icon: Icons.layers_outlined),
          Divider(height: 24),
          DetailRow(label: "Status", value: "Rejected", valueColor: Colors.red, icon: Icons.cancel_outlined),
        ],
      ),
    );
  }
}