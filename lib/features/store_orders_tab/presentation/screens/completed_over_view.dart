import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

import '../widgets/completed_widgets/complete_summury_card.dart';
import '../widgets/completed_widgets/completed_item_lists.dart';
import '../widgets/completed_widgets/print_action_footer.dart';

class CompletedOrderOverview extends StatelessWidget {
  final Order order;
  const CompletedOrderOverview({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CompletedSummaryCard(),
            SizedBox(height: 30),
            Text(
              "Ordered items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            CompletedItemsList(), //  vegetable list
          ],
        ),
      ),
      bottomNavigationBar: const PrintActionFooter(),
    );
  }
}
