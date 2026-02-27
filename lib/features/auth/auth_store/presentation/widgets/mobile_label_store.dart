import 'package:flutter/material.dart';

class MobileLabel extends StatelessWidget {
  const MobileLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        "Mobile Number",
        style: TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}
