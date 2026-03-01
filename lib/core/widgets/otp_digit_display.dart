import 'package:flutter/material.dart';

class OtpDigitDisplay extends StatelessWidget {
  final int otpLength;
  final String otp;
  final Color buttonColor;
  final FocusNode focusNode;

  const OtpDigitDisplay({
    super.key,
    required this.otpLength,
    required this.otp,
    required this.buttonColor,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(otpLength, (index) {
            final digit = index < otp.length ? otp[index] : '';
            final isFilled = digit.isNotEmpty;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFilled ? buttonColor : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    digit,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isFilled ? buttonColor : Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
