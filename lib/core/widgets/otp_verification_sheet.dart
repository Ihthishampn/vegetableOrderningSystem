import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';
import 'otp_header.dart';
import 'otp_digit_display.dart';
import 'otp_hidden_input.dart';
import 'otp_error_message.dart';
import 'otp_verify_button.dart';
import 'otp_resend_footer.dart';
import 'otp_sheet_decoration.dart';

class OtpVerificationSheet extends StatefulWidget {
  final String role;
  final VoidCallback? onSuccess;

  const OtpVerificationSheet({super.key, required this.role, this.onSuccess});

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _otpFocus = FocusNode();

  static const int _otpLength = 6;

  @override
  void dispose() {
    otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();
    final isStore = widget.role == 'store';
    final buttonColor = OtpSheetDecoration.getButtonColor(isStore);
    final decoration = OtpSheetDecoration.getDecoration(isStore);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: decoration,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OtpHeader(otpLength: _otpLength),
              OtpDigitDisplay(
                otpLength: _otpLength,
                otp: otpProvider.otp,
                buttonColor: buttonColor,
                focusNode: _otpFocus,
              ),
              const SizedBox(height: 12),
              OtpHiddenInput(
                controller: otpController,
                focusNode: _otpFocus,
                otpLength: _otpLength,
                formKey: _formKey,
              ),
              const OtpErrorMessage(),
              const SizedBox(height: 12),
              OtpVerifyButton(
                buttonColor: buttonColor,
                controller: otpController,
                formKey: _formKey,
                onSuccess: widget.onSuccess,
              ),
              const OtpResendFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
