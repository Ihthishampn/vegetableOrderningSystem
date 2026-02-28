import 'package:flutter/material.dart';

import 'pending_edit_order_screen.dart';

class OutlineBtn extends StatelessWidget {
  final String text;
  final Color color;
  const OutlineBtn({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => EditOrderScreen()));
    },
    style: OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 15),
    ),
    child: Text(text),
  );
}
