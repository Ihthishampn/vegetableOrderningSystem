import 'package:flutter/material.dart';

class StatusCardsRow extends StatelessWidget {
  const StatusCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            StatusCard(
              label: "Scheduled",
              value: "49",
              color: Color.fromARGB(255, 243, 96, 17),
            ),
            StatusCard(label: "Order", value: "251", color: Color(0xFFFFAC11)),
            StatusCard(label: "Completed", value: "203", color: Colors.green),
          ],
        ),
      ],
    );
  }
}

// status card ivideeee

class StatusCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const StatusCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: .w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
