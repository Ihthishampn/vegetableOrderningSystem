import 'package:flutter/material.dart';


class DatePickerFormField extends StatelessWidget {
  const DatePickerFormField({
    super.key,
    required this.selectedDate,
    required this.onDatePicked,
    this.hint = 'Select date',
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDatePicked;
  final String hint;

  String get _displayText {
    if (selectedDate == null) return hint;
    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onDatePicked(picked);
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          _displayText,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }
}
