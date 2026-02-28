

import 'package:flutter/material.dart';

class StoreLogoutButton extends StatelessWidget {
  const StoreLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Log out",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.logout, color: Colors.red, size: 18),
        ],
      ),
    );
  }
}
