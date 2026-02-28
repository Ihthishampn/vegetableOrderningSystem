import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

class RejectedItemsList extends StatelessWidget {
  final List<OrderItem> items;
  const RejectedItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final totalItems = items.fold<int>(0, (p, e) => p + e.quantity);

    return Column(
      children: [
        ...items.map((item) {
          final unit = item.unit ?? '';
          final displayQty = unit.isNotEmpty
              ? '${item.quantity} $unit'
              : item.quantity.toString();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(child: Text(item.productName)),
                Text(
                  displayQty,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                totalItems.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
