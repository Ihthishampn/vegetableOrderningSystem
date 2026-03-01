import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';

class OtpHiddenInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int otpLength;
  final GlobalKey<FormState> formKey;

  const OtpHiddenInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.otpLength,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthViewModel>();
    final otpProvider = context.read<OtpProvider>();

    return SizedBox(
      width: 0,
      height: 0,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: otpLength,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(otpLength),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        validator: (val) {
          if (authProvider.error != null) {
            return authProvider.error;
          }
          if (val == null || val.trim().length < otpLength) {
            return "Enter $otpLength digit code";
          }
          return null;
        },
        onChanged: (val) {
          otpProvider.updateOtp(val.trim());
          authProvider.clearError();
        },
      ),
    );
  }
}
