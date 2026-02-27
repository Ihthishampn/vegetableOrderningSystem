import 'package:flutter/material.dart';

class VegetableTopstatusCards extends StatelessWidget {
  final String title;
  const VegetableTopstatusCards({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white, width: 1.4),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: .w500),
          ),
        ),
      ),
    );
  }
}
