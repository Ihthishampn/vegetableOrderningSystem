import 'package:flutter/material.dart';

class OtpHeader extends StatelessWidget {
  final int otpLength;

  const OtpHeader({super.key, required this.otpLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "OTP Verification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter $otpLength digit verification\ncode sent to your mobile number",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
