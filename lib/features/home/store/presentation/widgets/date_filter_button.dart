import 'package:flutter/material.dart';

class DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateFilterButton({super.key, required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = selectedDate == null
        ? "Filter by Date"
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
