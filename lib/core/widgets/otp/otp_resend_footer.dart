import 'package:flutter/material.dart';

class OtpResendFooter extends StatelessWidget {
  const OtpResendFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 16),
        Text(
          "Didn't receive resend in 60 sec",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
