import 'package:flutter/material.dart';


class OutlineBtn extends StatelessWidget {
  final String text;
  final Color color;


  final VoidCallback onPressed;

  const OutlineBtn({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 15),
    ),
    child: Text(text),
  );
}
