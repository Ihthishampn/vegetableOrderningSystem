import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

class OrderItemCard extends StatelessWidget {
  final String storeName;
  final String date;
  final List<OrderItem> items;

  const OrderItemCard({
    super.key,
    required this.storeName,
    required this.date,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 300,

      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...items.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final item = entry.value;
              final unit = item.unit ?? '';
              final qtyStr = unit.isNotEmpty
                  ? '${item.quantity} $unit'
                  : '${item.quantity}';
              return _buildVegRow('$idx ${item.productName}', qtyStr);
            }),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVegRow(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.grey)),
          Text(qty, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
