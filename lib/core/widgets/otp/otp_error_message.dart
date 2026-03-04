import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/presentation/viewmodels/auth_viewmodel.dart';

class OtpErrorMessage extends StatelessWidget {
  const OtpErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthViewModel>();

    if (authProvider.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          authProvider.error!,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
