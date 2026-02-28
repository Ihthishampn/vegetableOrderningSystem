import 'package:flutter/material.dart';

class RejectedItemsList extends StatelessWidget {
  const RejectedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"id": "1", "name": "Ridge gourd", "qty": "20 Kg"},
      {"id": "2", "name": "Carrot", "qty": "15 Kg"},
      {"id": "3", "name": "Cauliflower", "qty": "10 Kg"},
      {"id": "4", "name": "Tomato", "qty": "20 Box"},
      {"id": "5", "name": "Green chili", "qty": "15 Kg"},
    ];

    return Column(
      children: [
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text("${item['id']} ", style: const TextStyle(color: Colors.grey)),
                  Expanded(child: Text(item['name']!)),
                  Text(item['qty']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, 
            borderRadius: BorderRadius.circular(8)
          ),
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
