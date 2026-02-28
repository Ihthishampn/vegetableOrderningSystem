import 'package:flutter/material.dart';

/// A single circle representing one digit in the OTP entry UI.
///
/// When [digit] is `null` or empty the circle is outlined; when it contains
/// a character the circle is filled and displays that character.
class OtpDigit extends StatelessWidget {
  final String? digit;
  final VoidCallback onTap;

  const OtpDigit({super.key, required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasDigit = digit != null && digit!.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: hasDigit ? Colors.black : Colors.transparent,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: hasDigit
            ? Text(
                digit!,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            : null,
      ),
    );
  }
}
