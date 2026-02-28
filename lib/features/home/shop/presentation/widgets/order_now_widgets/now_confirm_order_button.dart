

import 'package:flutter/material.dart';

class ConfirmOrderButton extends StatelessWidget {
  const ConfirmOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            // Confirm logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B7FFF), // Primary Blue
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            "Confirm Order",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}