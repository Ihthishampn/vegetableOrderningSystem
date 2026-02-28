import 'package:flutter/material.dart';

import 'row_items.dart';


class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

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
          RowItem(label: "Order ID", value: "ORD001", valueColor: Colors.blue),
          RowItem(label: "Shop", value: "Green Valley Wholesale", icon: Icons.store_outlined),
          RowItem(label: "Order Date", value: "24/11/2025, 02:30am", icon: Icons.calendar_today_outlined),
          RowItem(label: "Items", value: "5 Items", icon: Icons.layers_outlined),
        ],
      ),
    );
  }
}

