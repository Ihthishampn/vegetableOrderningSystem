import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';


class StoreOrderCard extends StatelessWidget {
  final int storeNumber;
  final String storeName;
  final String? orderId;
  final String? orderStatus;
  final double? totalPrice;
  final int? itemCount;
  final DateTime? createdAt;
  final List<OrderItem>? items;

  const StoreOrderCard({
    super.key,
    required this.storeNumber,
    required this.storeName,
    this.orderId,
    this.orderStatus,
    this.totalPrice,
    this.itemCount,
    this.items,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = createdAt != null
        ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}, ${createdAt!.hour}:${createdAt!.minute.toString().padLeft(2, '0')}${createdAt!.hour >= 12 ? 'pm' : 'am'}'
        : 'N/A';

  

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "$storeNumber. $storeName",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            if (items != null && items!.isNotEmpty) ...[
              ...items!.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final item = entry.value;
                final unit = item.unit ?? '';
                final displayQty = unit.isNotEmpty
                    ? '${item.quantity} $unit'
                    : item.quantity.toString();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('$idx ${item.productName}')),
                      Text(
                        displayQty,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else if (itemCount != null) ...[
              Text(
                'Items: $itemCount',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

}