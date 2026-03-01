import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label, value;
  final IconData? icon;
  final Color? color;
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          // make the value flexible so that long text can wrap/ellipsize and
          // avoid overflowing the row
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
