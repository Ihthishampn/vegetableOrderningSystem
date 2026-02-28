import 'package:flutter/material.dart';

class StoreOrderCard extends StatelessWidget {
  final int storeNumber;
  final String storeName;
  final String? orderId;
  final String? orderStatus;
  final double? totalPrice;
  final int? itemCount;
  final DateTime? createdAt;

  const StoreOrderCard({
    super.key,
    required this.storeNumber,
    required this.storeName,
    this.orderId,
    this.orderStatus,
    this.totalPrice,
    this.itemCount,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = createdAt != null
        ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}, ${createdAt!.hour}:${createdAt!.minute.toString().padLeft(2, '0')}${createdAt!.hour >= 12 ? 'pm' : 'am'}'
        : 'N/A';

    final statusColor = _getStatusColor(orderStatus);

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
                if (orderStatus != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 0.5),
                    ),
                    child: Text(
                      orderStatus!.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (itemCount != null)
                  Text(
                    'Items: $itemCount',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                if (totalPrice != null)
                  Text(
                    '₹${totalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
