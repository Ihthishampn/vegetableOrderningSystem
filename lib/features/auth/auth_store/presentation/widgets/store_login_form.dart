
import 'package:flutter/material.dart';

import 'login_title_store.dart';
import 'mobile_input_store.dart';
import 'mobile_label_store.dart';
import 'send_otp_store_button.dart';

class LoginFormStore extends StatelessWidget {
  final Size size;
  const LoginFormStore({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.04,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.65), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LoginTitleStore(),
          SizedBox(height: 24),
          MobileLabel(),
          SizedBox(height: 8),
          MobileInput(),
          SizedBox(height: 20),
          SendOtpButton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
