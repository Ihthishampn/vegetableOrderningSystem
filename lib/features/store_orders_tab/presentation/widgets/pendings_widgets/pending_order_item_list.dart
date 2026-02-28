import 'package:flutter/material.dart';

class OrderedItemsList extends StatelessWidget {
  const OrderedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {"n": "1 Ridge gourd", "q": "20 Kg"},
      {"n": "2 Carrot", "q": "15 Kg"},
      {"n": "3 Cauliflower", "q": "10 Kg"},
      {"n": "4 Tomato", "q": "20 Box"},
      {"n": "5 Green chili", "q": "15 Kg"},
    ];

    return Column(
      children: [
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['n']!),
                Text(
                  item['q']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Total Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("05"),
            ],
          ),
        ),
      ],
    );
  }
}
