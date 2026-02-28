

import 'package:flutter/material.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildButton(Icons.remove),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("01", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildButton(Icons.add),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(color: Colors.black12)),
      ),
      child: Icon(icon, size: 20, color: Colors.black54),
    );
  }
}