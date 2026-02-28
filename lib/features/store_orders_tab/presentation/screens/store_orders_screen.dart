import 'package:flutter/material.dart';

import '../widgets/order_screen_widgets/status_filter_bar.dart';
import '../widgets/order_screen_widgets/store_order_card.dart';

class StoreOrdersScreen extends StatelessWidget {
  const StoreOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const StatusFilterBar()),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, 
        itemBuilder: (context, index) {
          return const StoreOrderCard(
            storeNumber: 1,
            storeName: "Green Valley Store",
          );
        },
      ),
    );
  }
}
