import 'package:flutter/material.dart';

class LoginTitleStore extends StatelessWidget {
  const LoginTitleStore({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: "Enter your registered\n",
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: "mobile number",
            style: TextStyle(color: Colors.green),
          ),
          TextSpan(
            text: " to continue",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
