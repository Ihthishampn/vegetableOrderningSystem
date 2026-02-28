import 'package:flutter/material.dart';

import 'unit_chip.dart';

class DefaultUnitSelector extends StatefulWidget {
  final Function(String)? onUnitSelected;
  final String? initialUnit;

  const DefaultUnitSelector({
    super.key,
    this.onUnitSelected,
    this.initialUnit = 'Kg',
  });

  @override
  State<DefaultUnitSelector> createState() => _DefaultUnitSelectorState();
}

class _DefaultUnitSelectorState extends State<DefaultUnitSelector> {
  late String _selectedUnit;
  final List<String> _units = ['Kg', 'Box', 'Bag', 'Packet'];

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.initialUnit ?? 'Kg';
  }

  void _selectUnit(String unit) {
    setState(() => _selectedUnit = unit);
    if (widget.onUnitSelected != null) {
      widget.onUnitSelected!(unit);
    }
  }

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
        const SizedBox(height: 12),
        Row(
          children: _units.map((unit) {
            return GestureDetector(
              onTap: () => _selectUnit(unit),
              child: UnitChip(label: unit, isSelected: _selectedUnit == unit),
            );
          }).toList(),
        ),
      ],
    );
  }
}
