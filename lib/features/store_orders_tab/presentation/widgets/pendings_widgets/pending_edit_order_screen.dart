import 'package:flutter/material.dart';
import '../../../../store_orders_tab/domain/entities/order.dart';

import 'edit_item_card.dart';
import 'save_action_footer.dart';


class EditOrderScreen extends StatelessWidget {
  const EditOrderScreen({super.key, required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return EditItemCard(
            name: item.productName,
      
            imageUrl: item.productId, 
          );
        },
      ),
      bottomNavigationBar: const SaveActionFooter(),
    );
  }
}
