import 'package:flutter/material.dart';

class LoginTitleStore extends StatelessWidget {
  final Color blueOrgreen;
  final Color whiteOrblack;
  const LoginTitleStore({
    super.key,
    required this.blueOrgreen,
    required this.whiteOrblack, 
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text:  TextSpan(
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: "Enter your registered\n",
            style: TextStyle(color: whiteOrblack),
          ),
          TextSpan(
            text: "mobile number",
            style: TextStyle(color:blueOrgreen),
          ),
          TextSpan(
            text: " to continue",
            style: TextStyle(color:whiteOrblack),
          ),
        ],
      ),
    );
  }
}
