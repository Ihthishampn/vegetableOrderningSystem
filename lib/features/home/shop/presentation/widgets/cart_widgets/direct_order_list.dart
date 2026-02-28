

import 'package:flutter/material.dart';

import 'order_list_item.dart';


class DirectOrdersList extends StatelessWidget {
  const DirectOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: const [
        OrderListItem(
          orderId: "4. ORD1731234567890",
          status: "Approved",
          date: "18 Nov 2025, 10:00 am",
        ),
        OrderListItem(
          orderId: "6. ORD1731234567890",
          status: "Cancelled",
          date: "19 Nov 2025, 11:30 am",
        ),
      ],
    );
  }
}