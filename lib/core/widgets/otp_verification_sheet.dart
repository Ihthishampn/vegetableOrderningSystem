import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/auth/presentation/providers/otp_provider.dart';

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

  // length of the one-time password
  static const int _otpLength = 6;

  @override
  void dispose() {
    otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthViewModel>();
    final otpProvider = context.watch<OtpProvider>();

    // Role-based styling
    final isStore = widget.role == 'store';
    final buttonColor = isStore
        ? const Color(0xFF2D2926) // Black for store
        : const Color(0xFF5C79FF); // Blue for shop

    // Gradient decoration based on role
    final decoration = isStore
        ? const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            color: Colors.white,
          )
        : const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD4DCFF), Colors.white],
              stops: [0.0, 0.16],
            ),
          );

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
              const Text(
                "OTP Verification",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Enter $_otpLength digit verification\ncode sent to your mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),

              // OTP digit circles display - directly clickable and editable
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_otpFocus);
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_otpLength, (index) {
                      final digit = index < otpProvider.otp.length
                          ? otpProvider.otp[index]
                          : '';
                      final isFilled = digit.isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFilled
                                  ? buttonColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isFilled
                                    ? buttonColor
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Completely hidden input field - no visibility at all
              SizedBox(
                width: 0,
                height: 0,
                child: TextFormField(
                  focusNode: _otpFocus,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: _otpLength,
                  // enforce both numeric and length limits so users cannot
                  // accidentally enter a seventh digit (was causing 7
                  // circles to appear if they typed too fast).
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_otpLength),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  validator: (val) {
                    if (authProvider.error != null) {
                      return authProvider.error;
                    }
                    if (val == null || val.trim().length < _otpLength) {
                      return "Enter $_otpLength digit code";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    otpProvider.updateOtp(val.trim());
                    authProvider.clearError();
                  },
                ),
              ),

              // Error message display
              if (authProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await authProvider.verifyOtp(
                            otpController.text.trim(),
                          );

                          if (!mounted) return;

                          if (success) {
                            // clear any entered digits so the sheet is blank next
                            // time it's shown.  We clear both the hidden
                            // controller and the visual provider state.
                            otpController.clear();
                            otpProvider.clear();
                            widget.onSuccess?.call();
                          } else {
                            _formKey.currentState?.validate();
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
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
              ),

              const SizedBox(height: 16),
              const Text(
                "Didn't receive resend in 60 sec",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
