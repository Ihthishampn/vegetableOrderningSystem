import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';

class OtpVerifyButton extends StatelessWidget {
  final Color buttonColor;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSuccess;

  const OtpVerifyButton({
    super.key,
    required this.buttonColor,
    required this.controller,
    required this.formKey,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthViewModel>();
    final otpProvider = context.read<OtpProvider>();

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: authProvider.isLoading
            ? null
            : () async {
                if (!formKey.currentState!.validate()) return;

                final success = await authProvider.verifyOtp(
                  controller.text.trim(),
                );

                if (!context.mounted) return;

                if (success) {
                  otpProvider.clear();
                  onSuccess?.call();
                } else {
                  formKey.currentState?.validate();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Verify",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
