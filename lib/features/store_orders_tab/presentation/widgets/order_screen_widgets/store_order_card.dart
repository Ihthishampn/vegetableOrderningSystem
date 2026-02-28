import 'package:flutter/material.dart';

class StoreOrderCard extends StatelessWidget {
  final int storeNumber;
  final String storeName;

  const StoreOrderCard({
    super.key,
    required this.storeNumber,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$storeNumber. $storeName",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const OrderRow(index: 1, name: "Ridge gourd", qty: "20 Kg"),
            const OrderRow(index: 2, name: "Carrot", qty: "15 Kg"),
            const OrderRow(index: 3, name: "Cauliflower", qty: "10 Kg"),
            const OrderRow(index: 4, name: "Tomato", qty: "20 Box"),
            const OrderRow(index: 5, name: "Green chili", qty: "15 Kg"),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "24/11/2025, 04:30am",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderRow extends StatelessWidget {
  final int index;
  final String name;
  final String qty;

  const OrderRow({
    super.key,
    required this.index,
    required this.name,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$index ", style: const TextStyle(color: Colors.black)),
          Expanded(
            child: Text(name, style: const TextStyle(color: Colors.black87)),
          ),
          Text(qty, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
