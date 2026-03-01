import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/screens/role_select.dart';
import 'package:vegetable_ordering_system/core/widgets/confirm_confirmation_dilogue.dart';

import '../../../../../auth/presentation/viewmodels/auth_viewmodel.dart';

class ShopProfileLogOutButton extends StatelessWidget {
  const ShopProfileLogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => CustomConfirmationDialog(
                title: "Logout",
                message: "Are you sure you want to logout?",
                confirmText: "Yes",
                cancelText: "Cancel",
                primaryColor: Colors.red,
                onConfirm: () async {
                  final auth = context.read<AuthViewModel>();
                  await auth.logout();

                  if (!context.mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RoleSelect()),
                    (route) => false,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Logout",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
