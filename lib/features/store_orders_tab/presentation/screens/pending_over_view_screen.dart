import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';
import '../widgets/pendings_widgets/pending_action_footer.dart';
import '../widgets/pendings_widgets/pending_order_info_card.dart';
import '../widgets/pendings_widgets/pending_order_item_list.dart';

class PendingOrderOverview extends StatelessWidget {
  final Order order;
  const PendingOrderOverview({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            //  navigation logic
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderInfoCard(order: order),
            const SizedBox(height: 30),
            const Text(
              "Ordered items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            OrderedItemsList(items: order.items),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Use callback footer to allow store actions to update order status via provider
      bottomNavigationBar: PendingActionFooterWithCallback(order: order),
    );
  }
}
