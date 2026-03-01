import 'package:flutter/material.dart';

class RoleSelectHeader extends StatelessWidget {
  const RoleSelectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const Text(
          "Welcome",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2926),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Please select how you would like to\ncontinue using the app",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
