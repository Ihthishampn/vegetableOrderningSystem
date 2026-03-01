import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../repeat_last_order_widget/repeat_card_summary.dart';

class RepeatOrderHeader extends StatelessWidget {
  const RepeatOrderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProv, _) {
        final auth = Provider.of<AuthViewModel>(context, listen: false);
        final customerOrders = orderProv.allOrders
            .where((o) => o.customerId == auth.uid)
            .toList();
        customerOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (customerOrders.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No previous orders'),
          );
        }
        final last = customerOrders.first;
        final displayName = auth.storeName?.trim().isNotEmpty == true
            ? auth.storeName!
            : last.shopId?.trim().isNotEmpty == true
            ? last.shopId!
            : last.storeId;
        return OrderSummaryHeader(
          orderId: last.id,
          storeName: displayName,
          itemCount: last.items.length,
        );
      },
    );
  }
}
