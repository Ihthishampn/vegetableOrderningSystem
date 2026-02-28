import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  final String storeName, date;
  const OrderItemCard({super.key, required this.storeName, required this.date});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 300,

      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // container is white
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildVegRow("1 Ridge gourd", "20 Kg"),
            _buildVegRow("2 Carrot", "15 Kg"),
            _buildVegRow("3 Cauliflower", "10 Kg"),
            _buildVegRow("4 Tomato", "20 Box"),
            _buildVegRow("5 Green chili", "15 Kg"),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVegRow(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.grey)),
          Text(qty, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
