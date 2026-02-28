import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

class StatusFilterBar extends StatelessWidget {
  final OrderStatus selectedStatus;
  final ValueChanged<OrderStatus> onStatusSelected;

  const StatusFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  String _getStatusLabel(OrderStatus status) {
    final label = status.toString().split('.').last;
    return label[0].toUpperCase() + label.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [
      OrderStatus.pending,
      OrderStatus.approved,
      OrderStatus.completed,
      OrderStatus.rejected,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          final isActive = selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_getStatusLabel(status)),
              selected: isActive,
              onSelected: (_) => onStatusSelected(status),
              selectedColor: Colors.white,
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isActive ? Colors.black : Colors.transparent,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
