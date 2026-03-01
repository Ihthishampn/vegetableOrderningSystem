import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import 'order_list_item.dart';
import '../../screens/order_products_overview_screen.dart';

class DirectOrdersList extends StatelessWidget {
  final List<Order> orders;

  const DirectOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text('No orders', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return OrderListItem(
          order: o,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ShopOrderOverview(order: o)),
            );
          },
        );
      },
    );
  }
}
