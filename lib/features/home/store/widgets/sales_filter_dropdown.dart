import 'package:flutter/material.dart';

class SalesFilterDropdown extends StatelessWidget {
  final String value;
  final List<String> shops;
  final ValueChanged<String?> onChanged;

  const SalesFilterDropdown({
    super.key,
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
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox.shrink(),
        value: value,
        items: shops.map((shop) {
          return DropdownMenuItem<String>(value: shop, child: Text(shop));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
