import 'package:flutter/material.dart';

class UnitDropdown extends StatelessWidget {
  const UnitDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      ),
      hint: const Text("Kg, Box, Bag"),
      items: const [], // Add your items here
      onChanged: (val) {},
    );
  }
}

class UnitSelectorChips extends StatefulWidget {
  const UnitSelectorChips({super.key});

  @override
  State<UnitSelectorChips> createState() => _UnitSelectorChipsState();
}

class _UnitSelectorChipsState extends State<UnitSelectorChips> {
  String selected = "Kg";
  final List<String> options = ["Kg", "Box", "Bag", "Packet"];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        bool isSelected = selected == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => setState(() => selected = option),
          selectedColor: const Color(0xFF2D2926),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}