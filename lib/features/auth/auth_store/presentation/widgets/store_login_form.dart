import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/core/widgets/otp_verification_sheet.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';

import 'login_title_store.dart';
import 'mobile_input_store.dart';
import 'mobile_label_store.dart';
import 'send_otp_store_button.dart';

class LoginFormStore extends StatefulWidget {
  final Size size;

  final String role;

  final Color titleColor;

  final Color labelColor;

  final Widget successScreen;

  const LoginFormStore({
    super.key,
    required this.size,
    required this.role,
    required this.titleColor,
    required this.labelColor,
    required this.successScreen,
  });

  @override
  State<LoginFormStore> createState() => _LoginFormStoreState();
}

class _LoginFormStoreState extends State<LoginFormStore> {
  final TextEditingController mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: widget.size.width * 0.06,
            vertical: widget.size.height * 0.04,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.65), Colors.transparent],
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginTitleStore(
                  blueOrgreen: widget.titleColor,
                  whiteOrblack: widget.role == 'store'
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(height: 24),
                MobileLabel(color: widget.labelColor),
                const SizedBox(height: 8),
                MobileInput(
                  controller: mobileNumberController,
                  val: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Mobile number can't be empty";
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return "Enter valid 10 digit number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SendOtpButton(
                        isStore: widget.role == 'store',
                        ontap: () async {
                          FocusScope.of(context).unfocus();

                          if (formKey.currentState!.validate()) {
                            String fullNumber =
                                "+91${mobileNumberController.text.trim()}";

                            final success = await auth.checkUserRole(
                              phone: fullNumber,
                              selectedRole: widget.role,
                            );

                            if (!mounted) return;

                            if (success) {
                              final navigator = Navigator.of(context);

                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (sheetContext) => OtpVerificationSheet(
                                  role: widget.role,
                                  onSuccess: () {
                                    // Pop the bottom sheet using its own context
                                    Navigator.pop(sheetContext);
                                    // Then navigate to home screen
                                    navigator.pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => widget.successScreen,
                                      ),
                                      (route) => false,
                                    );
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    authProvider.error ??
                                        'Something went wrong',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
