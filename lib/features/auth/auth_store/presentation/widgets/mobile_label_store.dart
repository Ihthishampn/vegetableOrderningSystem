import 'package:flutter/material.dart';

class MobileLabel extends StatelessWidget {
  final Color color;
  const MobileLabel({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        "Mobile Number",
        style: TextStyle(color:color, fontSize: 11),
      ),
    );
  }
}
