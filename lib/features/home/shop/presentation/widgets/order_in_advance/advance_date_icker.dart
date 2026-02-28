import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  /// Text to display (typically formatted date)
  final String initialDate;

  /// Called when the user taps on the field
  final VoidCallback? onTap;

  const DatePickerField({super.key, required this.initialDate, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(initialDate, style: const TextStyle(color: Colors.black87)),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
