
import 'package:flutter/material.dart';

import 'advance_quantity_counter.dart';

class OrderProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<String> units;

  const OrderProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ), // Replaced with Image.network
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.close, color: Colors.red, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Unit Selectors
              Row(
                children: units.map((unit) {
                  bool isSelected = unit == "kg"; // Mocking selection
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: Colors.blue)
                          : null,
                    ),
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black54,
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Quantity Counter
              const QuantityCounter(),
            ],
          ),
        ],
      ),
    );
  }
}