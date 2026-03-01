import 'package:flutter/material.dart';

class SalesFilterDropdown extends StatelessWidget {
  final String value;
  final List<String> shops;
  final ValueChanged<String?> onChanged;

  const SalesFilterDropdown({
    required this.value,
    required this.shops,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value == "All" ? null : value,
          hint: Row(
            children: [
              Icon(Icons.filter_list, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              const Text(
                "Filter by Shop",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: shops.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
