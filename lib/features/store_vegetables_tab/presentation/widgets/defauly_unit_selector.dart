import 'package:flutter/material.dart';

import 'unit_chip.dart';

class DefaultUnitSelector extends StatelessWidget {
  const DefaultUnitSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Default Unit *",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: Color.fromARGB(255, 138, 138, 138),
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: "Kg, Box, Bag",
            hintStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: const [],
          onChanged: (v) {},
        ),
        const SizedBox(height: 8),
        const Text("Select Default unit", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          children: const [
            UnitChip(label: "Kg", isSelected: true),
            UnitChip(label: "Box", isSelected: false),
            UnitChip(label: "Bag", isSelected: false),
            UnitChip(label: "Packet", isSelected: false),
          ],
        ),
      ],
    );
  }
}