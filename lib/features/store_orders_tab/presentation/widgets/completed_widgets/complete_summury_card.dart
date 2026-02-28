import 'package:flutter/material.dart';

import 'my_row.dart';

class CompletedSummaryCard extends StatelessWidget {
  const CompletedSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF), // Soft blue theme from screenshot
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: const [
          MyRow(label: "Order ID", value: "ORD001", vColor: Colors.blue),
          MyRow(label: "Shop", value: "Green Valley Wholesale", icon: Icons.store_outlined),
          MyRow(label: "Order Date", value: "24/11/2025, 02:30am", icon: Icons.calendar_today_outlined),
          MyRow(label: "Items", value: "5 Items", icon: Icons.layers_outlined),
        ]
      ),
    );
  }
}
