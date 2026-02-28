
import 'package:flutter/material.dart';

class OrderTypeToggle extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const OrderTypeToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2626),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab("Scheduled 11", selectedIndex == 0, () => onChanged(0)),
          _buildTab("Order 10", selectedIndex == 1, () => onChanged(1)),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: Colors.white, width: 0.5)
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
