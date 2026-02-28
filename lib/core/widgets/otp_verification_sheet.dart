import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/provider/auth_provider.dart';

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
  String? _verificationError;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD4DCFF), Colors.white],
            stops: [0.0, 0.16],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "OTP Verification",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: "Enter 6 digit OTP",
                  border: OutlineInputBorder(),
                  errorText: _verificationError,
                ),
                validator: (value) {
                  if (_verificationError != null) return _verificationError;
                  if (value == null || value.trim().isEmpty) {
                    return "OTP can't be empty";
                  }
                  if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                    return "Enter valid 6 digit OTP";
                  }
                  return null; 
                },
                onChanged: (val) {
                  if (_verificationError != null) {
                    setState(() => _verificationError = null);
                    _formKey.currentState?.validate();
                  }
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
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
                            Navigator.pop(context);
                            widget.onSuccess?.call();
                          } else {
                            setState(() {
                              _verificationError =
                                  authProvider.error ?? "Verification failed";
                            });
                            _formKey.currentState?.validate();
                          }
                        },
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Verify"),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
