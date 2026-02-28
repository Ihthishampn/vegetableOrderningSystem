import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/domain/entities/order.dart';

class StatusFilterBar extends StatefulWidget {
  const StatusFilterBar({super.key});

  @override
  State<StatusFilterBar> createState() => _StatusFilterBarState();
}

class _StatusFilterBarState extends State<StatusFilterBar> {
  late OrderStatus _selectedStatus;
  final List<OrderStatus> statuses = [
    OrderStatus.pending,
    OrderStatus.approved,
    OrderStatus.completed,
    OrderStatus.rejected,
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = OrderStatus.pending;
  }

  String _getStatusLabel(OrderStatus status) {
    return status
        .toString()
        .split('.')
        .last
        .replaceFirst(
          status.toString().split('.').last[0],
          status.toString().split('.').last[0].toUpperCase(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          bool isActive = _selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_getStatusLabel(status)),
              selected: isActive,
              onSelected: (_) {
                setState(() => _selectedStatus = status);
                // Notify listeners if needed for filtering
              },
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
