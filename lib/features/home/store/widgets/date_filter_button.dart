import 'package:flutter/material.dart';

class DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateFilterButton({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDate != null
        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
        : "Select Date";

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(dateText, style: const TextStyle(fontSize: 14)),
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
