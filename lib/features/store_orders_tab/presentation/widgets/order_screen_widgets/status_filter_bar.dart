import 'package:flutter/material.dart';

class StatusFilterBar extends StatefulWidget {
  const StatusFilterBar({super.key});

  @override
  State<StatusFilterBar> createState() => _StatusFilterBarState();
}

class _StatusFilterBarState extends State<StatusFilterBar> {
  String activeStatus = "Pending";
  final List<String> statuses = ["Pending", "Approved", "Rejected", "Completed"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          bool isActive = activeStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: isActive,
              onSelected: (_) => setState(() => activeStatus = status),
              selectedColor: Colors.white,
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: isActive ? Colors.black : Colors.transparent),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}