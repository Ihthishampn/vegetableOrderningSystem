import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'repeat_order_item_row.dart';

class RepeatOrderItemsList extends StatelessWidget {
  const RepeatOrderItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(
        builder: (context, orderProv, _) {
          final auth = Provider.of<AuthViewModel>(context, listen: false);
          final customerOrders = orderProv.allOrders
              .where((o) => o.customerId == auth.uid)
              .toList();
          if (customerOrders.isEmpty) {
            return const Center(child: Text('No items'));
          }
          customerOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final last = customerOrders.first;
          return ListView.builder(
            itemCount: last.items.length,
            itemBuilder: (context, idx) {
              final item = last.items[idx];
              return OrderItemRow(
                index: idx + 1,
                name: item.productName,
                quantity: '${item.quantity}',
              );
            },
          );
        },
      ),
    );
  }
}
