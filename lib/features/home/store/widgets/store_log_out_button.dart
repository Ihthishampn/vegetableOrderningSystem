import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/screens/role_select.dart';
import 'package:vegetable_ordering_system/core/widgets/otp/confirm_confirmation_dilogue.dart';

class StoreLogoutButton extends StatelessWidget {
  const StoreLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
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
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Log out",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Icon(Icons.logout, color: Colors.red, size: 18),
        ],
      ),
    );
  }
}
