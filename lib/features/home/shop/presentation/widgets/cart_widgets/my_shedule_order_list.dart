
import 'package:flutter/material.dart';

import 'order_list_item.dart';

class ScheduledOrdersList extends StatelessWidget {
  const ScheduledOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: const [
        OrderListItem(
          orderId: "1. ORD1731234567890",
          status: "Ordered",
          date: "17 Nov 2025, 08:53 am",
        ),
        OrderListItem(
          orderId: "3. ORD1731234567890",
          status: "Completed",
          date: "17 Nov 2025, 08:53 am",
        ),
        OrderListItem(
          orderId: "5. ORD1731234567890",
          status: "Rejected",
          date: "17 Feb 2025",
          deliveryDate: "25 Feb 2025",
        ),
      ],
    );
  }
}
