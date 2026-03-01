import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import '../widgets/repeat_last_order_widget/repeat_order_header.dart';
import '../widgets/repeat_last_order_widget/repeat_order_items_list.dart';
import '../widgets/repeat_last_order_widget/repeat_total_items_footer.dart';
import '../widgets/repeat_last_order_widget/repeat_order_actions.dart';

class RepeatLastOrder extends StatelessWidget {
  const RepeatLastOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    if (orderProv.storeId == null && auth.storeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProv.initialize(auth.storeId!);
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Previous Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          RepeatOrderHeader(),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ordered items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  RepeatOrderItemsList(),
                ],
              ),
            ),
          ),
          const TotalItemsFooter(total: "05"),
          RepeatOrderActions(),
        ],
      ),
    );
  }
}
