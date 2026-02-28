import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'order_list_item.dart';

class ScheduledOrdersList extends StatelessWidget {
  final List<Order> orders;

  const ScheduledOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No scheduled orders',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return OrderListItem(order: o);
      },
    );
  }
}
