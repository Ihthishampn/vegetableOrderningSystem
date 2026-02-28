
import 'package:flutter/material.dart';

class StatusFilterBarCart extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const StatusFilterBarCart({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = ['All', 'Approved', 'Rejected', 'Cancelled', 'Completed'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: statuses.map((status) {
          final isSelected = selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (_) => onStatusSelected(status),
              backgroundColor: const Color(0xFFF5F5F5),
              selectedColor: const Color(0xFFE0E0E0),
              labelStyle: const TextStyle(color: Colors.black87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            ),
          );
        }).toList(),
      ),
    );
  }
}
