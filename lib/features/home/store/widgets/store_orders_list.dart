import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'home_order_items_store.dart';

class StoreOrdersList extends StatelessWidget {
  final String Function(DateTime) formatDate;

  const StoreOrdersList({
    super.key,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orders, _) {
        if (orders.isLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (orders.error != null) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${orders.error}'),
              ),
            ),
          );
        }

        final list = orders.allOrders;
        if (list.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('No orders yet'),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final order = list[index];
            final storeName = order.customerName.isNotEmpty
                ? order.customerName
                : 'Shop';
            final date = formatDate(order.createdAt);
            return OrderItemCard(
              storeName: storeName,
              date: date,
              items: order.items,
            );
          }, childCount: list.length),
        );
      },
    );
  }
}
