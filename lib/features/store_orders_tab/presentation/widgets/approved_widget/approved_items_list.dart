import 'package:flutter/material.dart';

class ApprovedItemsList extends StatelessWidget {
  const ApprovedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"name": "1 Ridge gourd", "qty": "20 Kg"},
      {"name": "2 Carrot", "qty": "15 Kg"},
      {"name": "3 Cauliflower", "qty": "10 Kg"},
      {"name": "4 Tomato", "qty": "20 Box"},
      {"name": "5 Green chili", "qty": "15 Kg"},
    ];

    return Column(
      children: [
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name']!),
                  Text(item['qty']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Items", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("05", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}